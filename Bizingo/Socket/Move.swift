//
//  Move.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 14/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct Move: Codable {
    
    var from: Coordinate
    var to: Coordinate
    
    struct Coordinate: Codable {
        
        var row: Int
        var column: Int
        
        init(row: Int, column: Int) {
            self.row = row
            self.column = column
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            row = try values.decodeIfPresent(Int.self, forKey: .row) ?? 0
            column = try values.decodeIfPresent(Int.self, forKey: .column) ?? 0
        }
        
        enum CodingKeys: String, CodingKey {
            case row
            case column
        }
        
    }
    
}

extension Move {
    
    init(from: Cell, to: Cell) {
        self.from = Coordinate(row: from.row, column: from.column)
        self.to = Coordinate(row: to.row, column: to.column)
    }
    
}
