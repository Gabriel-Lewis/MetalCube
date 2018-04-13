//
//  ViewController.swift
//  MetalTest
//
//  Created by Gabriel Lewis on 4/12/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import UIKit
import MetalKit
import simd

protocol MetalViewControllerDelegate : class{
    func updateLogic(timeSinceLastUpdate: CFTimeInterval)
    func renderObjects(drawable: CAMetalDrawable)
}

class MetalViewController: UIViewController {
    @IBOutlet weak var mtlView: MTKView! {
        didSet {
            mtlView.delegate = self
            mtlView.preferredFramesPerSecond = 60
            mtlView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    weak var metalViewControllerDelegate: MetalViewControllerDelegate?
    lazy var device: MTLDevice = MTLCreateSystemDefaultDevice()!

    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var projectionMatrix: float4x4!
    var textureLoader: MTKTextureLoader! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        textureLoader = MTKTextureLoader(device: device)
        mtlView.device = device
        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 85.0), aspectRatio: Float(375.0 / 734.0), nearZ: 0.01, farZ: 100.0)

        // 1
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")

        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // 3
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        commandQueue = device.makeCommandQueue()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        if let window = view.window {
            let scale = window.screen.nativeScale
            let layerSize = view.bounds.size
            view.contentScaleFactor = scale


        }

        projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 85.0), aspectRatio: Float(frame.size.width / frame.size.height), nearZ: 0.01, farZ: 100.0)
    }

    func render(_ drawable: CAMetalDrawable?) {
        guard let drawable = drawable else { return }
        self.metalViewControllerDelegate?.renderObjects(drawable: drawable)
    }
}

extension MetalViewController: MTKViewDelegate {

    // 1
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        guard let window = view.window else { return }
        let scale = window.screen.nativeScale
        let layerSize = view.bounds.size
        view.contentScaleFactor = scale

        projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 85.0),
                                                             aspectRatio: Float(self.mtlView.bounds.size.width / self.mtlView.bounds.size.height),
                                                             nearZ: 0.01, farZ: 100.0)
    }

    // 2
    func draw(in view: MTKView) {
        render(view.currentDrawable)
    }

}

