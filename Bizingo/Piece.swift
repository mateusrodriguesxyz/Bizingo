//
//  Piece.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 14/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import SpriteKit

class Piece: SKShapeNode {
    
    var isCaptain: Bool
    
    var number: Int
    
    init(color: UIColor, isCaptain: Bool, number: Int) {
        self.isCaptain = isCaptain
        self.number = number
        super.init()
        self.strokeColor = .clear
        self.fillColor = color
        self.path = SKShapeNode(circleOfRadius: 10).path
        if isCaptain {
            let badge = SKShapeNode(circleOfRadius: 5)
            badge.strokeColor = .clear
            badge.fillColor = .white
            self.addChild(badge)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
