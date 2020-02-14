//
//  Cell.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 04/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import SpriteKit

class Cell: Codable {
    
    var row: Int
    var column: Int
    var rotation: CGFloat
    var position: CGPoint!
    var hasPiece: Bool
    var node: Triangle!
    
    var color: UIColor {
        let c1 = UIColor.systemGray3
        let c2 = UIColor.systemGray6
        return rotation == 0 ? c1 : c2
    }
    
    var isHightlighted = false {
        willSet {
            if newValue {
                let c1 = UIColor.systemRed
                let c2 = UIColor.systemBlue
                node.fillColor = rotation == 0 ?  c1 : c2
            } else {
                node.fillColor = color
            }
        }
    }
    
    var neighbors: [Cell] = []
    
    init(row: Int, column: Int, rotation: CGFloat, hasPiece: Bool = false) {
        self.row = row
        self.column = column
        self.rotation = rotation
        self.hasPiece = hasPiece
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.row = try values.decode(Int.self, forKey: .row)
        self.column = try values.decode(Int.self, forKey: .column)
        self.rotation = try values.decode(CGFloat.self, forKey: .rotation)
        self.position = try values.decode(CGPoint.self, forKey: .position)
        self.hasPiece = try values.decode(Bool.self, forKey: .hasPeice)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(row, forKey: .row)
        try container.encode(column, forKey: .column)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(position, forKey: .position)
        try container.encode(hasPiece, forKey: .hasPeice)
    }
    
    enum CodingKeys: String, CodingKey {
        case row
        case column
        case rotation
        case position
        case hasPeice
    }
    
}
