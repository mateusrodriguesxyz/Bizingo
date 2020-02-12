//
//  Cell.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 04/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import SpriteKit

class Cell {
    
    var row: Int
    var column: Int
    var color: UIColor
    var rotation: CGFloat
    var node: Triangle!
    
    var isHightlighted = false {
        willSet {
            if newValue {
                node.fillColor = .orange
            } else {
                node.fillColor = color
            }
        }
    }
    
    init(row: Int, column: Int, color: UIColor, rotation: CGFloat) {
        self.row = row
        self.column = column
        self.color = color
        self.rotation = rotation
    }
    
}
