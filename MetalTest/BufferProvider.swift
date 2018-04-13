//
//  BufferProvider.swift
//  MetalTest
//
//  Created by Gabriel Lewis on 4/12/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Metal
import simd

class BufferProvider {
    let inflightBuffersCount: Int
    private var uniformBuffers: [MTLBuffer]
    private var availableBufferIndex: Int = 0
    var avaliableResourcesSemaphore: DispatchSemaphore

    init(device:MTLDevice, inflightBuffersCount: Int, sizeOfUniformsBuffer: Int) {

        self.inflightBuffersCount = inflightBuffersCount
        uniformBuffers = [MTLBuffer]()

        for _ in 0...inflightBuffersCount-1 {
            guard let _uniformBuffer = device.makeBuffer(length: sizeOfUniformsBuffer, options: []) else { continue }
            uniformBuffers.append(_uniformBuffer)
        }
        avaliableResourcesSemaphore = DispatchSemaphore(value: inflightBuffersCount)
    }

    deinit{
        for _ in 0...self.inflightBuffersCount{
            self.avaliableResourcesSemaphore.signal()
        }
    }

    func nextUniformsBuffer(projectionMatrix: float4x4, modelViewMatrix: float4x4, light: Light) -> MTLBuffer {

        // 1
        let buffer = uniformBuffers[availableBufferIndex]

        // 2
        let bufferPointer = buffer.contents()

        var projectionMatrix = projectionMatrix
        var modelViewMatrix = modelViewMatrix

        // 3

        memcpy(bufferPointer, &modelViewMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size*float4x4.numberOfElements(), &projectionMatrix, MemoryLayout<Float>.size*float4x4.numberOfElements())
        memcpy(bufferPointer + 2*MemoryLayout<Float>.size*float4x4.numberOfElements(), light.raw(), Light.size())

        // 4
        availableBufferIndex += 1
        if availableBufferIndex == inflightBuffersCount{
            availableBufferIndex = 0
        }

        return buffer
    }
}
