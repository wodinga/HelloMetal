struct Vertex{
	
	var x,y,z: Float //position data
	var r,g,b,a: Float // color data
	
	func floatBuffer() -> [Float] {
		return [x,y,z,r,g,b,a]
	}
}
