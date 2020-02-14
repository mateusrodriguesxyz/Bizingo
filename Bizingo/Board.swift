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
    
    init?(contentsOf file: URL) {
        do {
            let data = try Data(contentsOf: file)
            self.cells = try JSONDecoder().decode([Cell].self, from: data)
            self.cells.forEach { (cell) in
                cell.node = Triangle(side: 50)
                cell.node.position = cell.position!
                cell.node.zRotation = cell.rotation
                cell.node.fillColor = cell.color
                cell.node.strokeColor = .clear
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
//    private func setup() {
//        var numberOfCellsPerRow = 5
//        for i in 0..<numberOfRows {
//            for j in 0..<numberOfCellsPerRow {
//                let cell = makeCellFor(row: i, column: j)
//                let node = makeTriangleFor(cell)
//                cell.position = node.position
//                cell.node = node
//                cells.append(cell)
//            }
//            if i < 8 {
//                numberOfCellsPerRow += 2
//            }
//            if i > 8 {
//                numberOfCellsPerRow -= 2
//            }
//        }
//    }
//
//    private func makeCellFor(row: Int, column: Int) -> Cell {
//        let rotations: (CGFloat, CGFloat) = (row < 9) ? (.zero, .pi) : (.pi, .zero)
//        let rotation: CGFloat = column.isMultiple(of: 2) ? rotations.0 : rotations.1
//        return Cell(row: row, column: column, rotation: rotation)
//    }
//
//    private func makeTriangleFor(_ cell: Cell) -> Triangle {
//
//        let side: CGFloat = 50
//
//        let triangle = Triangle(side: side)
//
//        triangle.strokeColor = .clear
//        triangle.fillColor = cell.color
//        triangle.zRotation = cell.rotation
//        triangle.position.x += CGFloat(cell.column)*(side/2)
//        triangle.position.y -= CGFloat(cell.row)*(side*sqrt(3)/2)
//
//        triangle.position.x -= side + CGFloat(cell.row)*(side/2)
//        triangle.position.y += 5*side
//
//        if cell.row == 9 {
//            triangle.position.x += side/2
//        }
//        if cell.row == 10 {
//            triangle.position.x += 3*side/2
//        }
//
//        return triangle
//    }
    
}
