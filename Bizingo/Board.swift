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
    
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}
