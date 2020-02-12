//
//  Board.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 02/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import SpriteKit

class Board {
    
    private let numberOfRows = 11
    
    var cells: [Cell] = []
    
    init() {
        setup()
    }
    
    private func setup() {
        var numberOfCellsPerRow = 5
        for i in 0..<numberOfRows {
            for j in 0..<numberOfCellsPerRow {
                let cell = makeCellFor(row: i, column: j)
                let node = makeTriangleFor(cell)
                cell.node = node
                cells.append(cell)
            }
            if i < 8 {
                numberOfCellsPerRow += 2
            }
            if i > 8 {
                numberOfCellsPerRow -= 2
            }
        }
    }
    
    private func makeCellFor(row: Int, column: Int) -> Cell {
        let c1 = UIColor.systemGray3
        let c2 = UIColor.systemGray6
        let colors: (UIColor, UIColor) = (row < 9) ? (c1, c2) : (c2, c1)
        let rotations: (CGFloat, CGFloat) = (row < 9) ? (.zero, .pi) : (.pi, .zero)
        let color: UIColor = column.isMultiple(of: 2) ? colors.0 : colors.1
        let rotation: CGFloat = column.isMultiple(of: 2) ? rotations.0 : rotations.1
        return Cell(row: row, column: column, color: color, rotation: rotation)
    }
    
    private func makeTriangleFor(_ cell: Cell) -> Triangle {
        
        let side: CGFloat = 50
        
        let triangle = Triangle(side: side)
        
        triangle.strokeColor = .clear
        triangle.fillColor = cell.color
        triangle.zRotation = cell.rotation
        triangle.position.x += CGFloat(cell.column)*(side/2)
        triangle.position.y -= CGFloat(cell.row)*(side*sqrt(3)/2)
        
        triangle.position.x -= side + CGFloat(cell.row)*(side/2)
        triangle.position.y += 5*side
        
        if cell.row == 9 {
             triangle.position.x += side/2
        }
        if cell.row == 10 {
            triangle.position.x += 3*side/2
        }
        
        return triangle
    }
    
}
