//
//  SKShapeNode.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 31/01/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import SpriteKit

class Triangle: SKShapeNode {
    
    public var radius: CGFloat {
        return frame.width*sqrt(3)/6
    }
    
    public var centroid: CGPoint {
        if zRotation == .zero {
            return CGPoint(x: frame.midX, y: frame.minY+radius)
        } else {
            return CGPoint(x: frame.midX, y: frame.maxY-radius)
        }
    }
    
    init(side: CGFloat) {
        super.init()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.5, y: sqrt(3)/2))
        path.addLine(to: CGPoint(x: 1.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        path.apply(.init(scaleX: side, y: side))
        self.path = SKShapeNode(path: path.cgPath, centered: true).path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
