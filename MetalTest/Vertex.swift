//
//  Vertex.swift
//  MetalTest
//
//  Created by Gabriel Lewis on 4/12/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import Foundation

struct Vertex {

    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    var s, t: Float // texture coordinates
    var nX, nY, nZ: Float // normal

    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a,s,t,nX,nY,nZ]
    }

}
