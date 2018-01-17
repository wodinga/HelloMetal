//
//  Cube.swift
//  HelloMetal
//
//  Created by David Garcia on 12/20/17.
//  Copyright © 2017 David Garcia. All rights reserved.
//

import Foundation
import Metal


class Cube: Node {
	init(device: MTLDevice){
		let A = Vertex(x:	-1.0, y:	 1.0, z:	1.0, r:	1.0, g:	0.0, b:	0.0, a:	1.0)
		let B = Vertex(x:	-1.0, y:	-1.0, z:	1.0, r:	0.0, g:	1.0, b:	0.0, a:	1.0)
		let C = Vertex(x:	1.0,  y:	-1.0, z:	1.0, r:	0.0, g:	0.0, b:	1.0, a:	1.0)
		let D = Vertex(x:	1.0,  y:	 1.0, z:	1.0, r:	0.1, g:	0.6, b:	0.4, a:	1.0)
		
		let Q = Vertex(x:	-1.0, y:	1.0,  z:	-1.0, r:	1.0, g:	0.0, b:	0.0, a:	1.0)
		let R = Vertex(x:	1.0, y:		1.0,  z:	-1.0, r:	0.0, g:	1.0, b:	0.0, a:	1.0)
		let S = Vertex(x:	-1.0, y:	-1.0, z:	-1.0, r:	0.0, g:	0.0, b:	1.0, a:	1.0)
		let T = Vertex(x:	1.0, y:		-1.0, z:	-1.0, r:	0.1, g:	0.6, b:	0.4, a:	1.0)
		
		let verticesArray:Array<Vertex> = [
			A,B,C, A, C, D,
			R,T,S, Q, R, S,
			
			Q,S,B ,Q, B, A,
			D,C,T ,D, T, R,
			
			Q,A,D ,Q, D, R,
			B,S,T ,B, T, C
		]
		
		super.init(name: "Cube", vertices: verticesArray, device: device)
	}
	
	override func updateWithDelta(delta: CFTimeInterval) {
		super.updateWithDelta(delta: delta)
		
		let secsPerMove: Float = 6.0
		rotationY = sinf(Float(time) * 2.0 * Float(Double.pi) / secsPerMove)
		rotationX = sinf(Float(time) * 2.0 * Float(Double.pi) / secsPerMove)
	}
}
