//
//  Triangle.swift
//  MetalTest
//
//  Created by Gabriel Lewis on 4/12/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation

import Metal

class Triangle: Node {

    init(device: MTLDevice, texture: MTLTexture){
        let vertices = Triangle.generateVertices()
        super.init(name: #function, vertices: vertices, device: device, texture: texture)
    }

    static func generateVertices() -> [Vertex] {
        var vertices: [Vertex] = []
        for _ in 0..<3 {
            vertices.append(createRandomVertex())
        }
        return vertices
    }

    static func createRandomVertex() -> Vertex {
        return Vertex(x: .random, y: .random, z: .random, r: .random, g: .random, b: .random, a: 1.0, s: .random, t: .random, nX: .random, nY: .random, nZ: .random)
    }

}

extension Float {
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random num Float

     - parameter min: Float
     - parameter max: Float

     - returns: Float
     */
    public static func random(_ min: Float = 0.0, _ max: Float = 1.0) -> Float {
        return Float.random * (max - min) + min
    }
}
