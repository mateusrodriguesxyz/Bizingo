//
//  GameScene.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 31/01/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let board = Board(contentsOf: Bundle.main.url(forResource: "board", withExtension: "json")!)!
    
    var pieces = [Piece]()
    
    var pieceToMove: Piece? = nil
    
    var highlightedCells: [Cell] = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        

        board.cells.forEach { (cell) in
            self.addChild(cell.node)
            if cell.hasPiece {
                let isCaptain = [(5,4), (5,10), (7,5), (7,13)].contains { $0 == (cell.row, cell.column)}
                let color = cell.rotation == 0 ? UIColor.systemRed: UIColor.systemBlue
                let piece = Piece(color: color, isCaptain: isCaptain)
                piece.position = cell.node.centroid
                piece.zPosition = 1
                self.pieces.append(piece)
                self.addChild(piece)
            }
        }
        
        children.forEach {
            print($0.zPosition)
        }
        
//        do {
//            let data = try JSONEncoder().encode(board.cells)
//            let string = String(data: data, encoding: .utf8)
//            print(string!)
//        } catch {
//            fatalError()
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        if pieceToMove != nil {
            if let cell = highlightedCells.first(where: { $0.node.contains(position)} ) {
                let currentPosition = pieceToMove?.position
                pieceToMove?.position = cell.node.centroid
                highlightedCells.forEach {
                    $0.isHightlighted = false
                }
                board.cells.forEach { (cell) in
                    print(cell.node.centroid, currentPosition)
                }
                if let cellForPiece = board.cells.first(where: { $0.node.contains(currentPosition!) }) {
                    cellForPiece.hasPiece = false
                } else {
                    
                }
                cell.hasPiece = true
                pieceToMove = nil
                highlightedCells.removeAll()
            }
        } else {
            
            guard let piece = pieces.first(where: { $0.contains(position)} ) else { return }
                    
            self.pieceToMove = piece
            
            guard let triangle = children.first(where: { $0.contains(position) && $0 is Triangle } ) else { return }
            
            board.cells.forEach { (cell) in
                let distance = CGPointDistanceSquared(from: triangle.position, to: cell.node.position)
                if distance.rounded(.up) == pow(triangle.frame.width, 2) && cell.node.zRotation == triangle.zRotation {
                    if !cell.hasPiece {
                        cell.isHightlighted = true
                        self.highlightedCells.append(cell)
                    } else {
                        cell.isHightlighted = false
                    }
                    
                } else {
                    cell.isHightlighted = false
                }
            }
        }

    }
    
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}
