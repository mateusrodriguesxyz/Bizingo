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
    
    var pieces: [Piece] = []
    
    init?(contentsOf file: URL) {
        do {
            let data = try Data(contentsOf: file)
            self.cells = try JSONDecoder().decode([Cell].self, from: data)
            
            self.cells.forEach { (cell) in
                cell.node = Triangle(side: 50)
                cell.node.position = cell.position
                cell.node.zRotation = cell.rotation
                cell.node.fillColor = cell.color
                cell.node.strokeColor = .clear
            }
            
            self.cells.forEach { (cell) in
                
                if cell.hasPiece {
                    let isCaptain = [(5,4), (5,10), (7,5), (7,13)].contains { $0 == (cell.row, cell.column)}
                    let color = cell.rotation == 0 ? UIColor.systemRed : UIColor.systemBlue
                    let number = cell.rotation == 0 ? 1 : 0
                    let piece = Piece(color: color, isCaptain: isCaptain, number: number)
                    piece.position = cell.node.centroid
                    piece.zPosition = 1
                    self.pieces.append(piece)
                }

                self.cells.forEach {
                    let distance1 = CGPointDistanceSquared(from: cell.node.position, to: $0.node.position)
                    let distance2 = CGPointDistanceSquared(from: cell.node.centroid, to: $0.node.centroid)
                    if distance1.rounded(.up) == pow(50, 2) || distance2.rounded(.up) == (2500/3).rounded(.up) {
                        cell.neighbors.append($0)
                    }
                }
                
            }
            
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    func cell(at position: CGPoint) -> Cell? {
        return self.cells.first(where: { $0.node.contains(position) })
    }
    
    func piece(at position: CGPoint) -> Piece? {
        return self.pieces.first(where: { $0.contains(position)} )
    }
    
    func placeCells(at scene: SKScene) {
        cells.forEach {
            scene.addChild($0.node)
        }
    }
    
    func placePieces(at scene: SKScene) {
        pieces.forEach {
            scene.addChild($0)
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
