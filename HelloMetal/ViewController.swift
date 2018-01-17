//
//  ViewController.swift
//  HelloMetal
//
//  Created by David Garcia on 12/16/17.
//  Copyright © 2017 David Garcia. All rights reserved.
//

import UIKit
import Metal

class ViewController: UIViewController {

    var device: MTLDevice!
    var timer: CADisplayLink!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue:MTLCommandQueue!
	var projectionMatrix: Matrix4!
	var lastFrameTimestamp: CFTimeInterval = 0.0
    
	var objectToDraw: Cube!
    var zIncrement = 1.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
		projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0),
															aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)
		device = MTLCreateSystemDefaultDevice()
		let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
		
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		
		pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
		
        //Create metal layer
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
		objectToDraw = Cube(device: device)
		
        
        commandQueue = device.makeCommandQueue()
        
		timer = CADisplayLink(target: self, selector: #selector(ViewController.newFrame(displayLink:)))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func render() {
		guard let drawable = metalLayer?.nextDrawable() else { return }
		let worldModelMatrix = Matrix4()
		worldModelMatrix.translate(0.0, y: 0.0, z: -7.0)
		worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 25), y: 0.0, z: 0.0)
		
		objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
		
	}

	@objc func newFrame(displayLink: CADisplayLink){
		if(lastFrameTimestamp == 0.0)
		{
			lastFrameTimestamp = displayLink.timestamp
		}
		
		let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
		lastFrameTimestamp = displayLink.timestamp
		
		gameloop(timeSinceLastUpdate: elapsed)
	}
	
	func gameloop(timeSinceLastUpdate: CFTimeInterval)
	{
		objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)
		
			autoreleasepool{
				self.render()
		}
	}

}

