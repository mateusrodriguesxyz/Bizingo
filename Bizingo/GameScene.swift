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
    
    var selectedPiece: Piece! = nil
    
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
        
        SCKManager.shared.getGameMovement { (move) in
            if let move = move {
                self.apply(move: move)
            }
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
        
        if selectedPiece != nil {
            if let destination = highlightedCells.first(where: { $0.node.contains(position)} ) {
                
                let origin = board.cells.first(where: { $0.node.contains(selectedPiece.position) })
                
                SCKManager.shared.send(movement: .init(from: origin!, to: destination))
                
                selectedPiece = nil
                
                clearHighlightedCell()
            }
        } else {
            
            guard let piece = pieces.first(where: { $0.contains(position)} ) else { return }
                    
            self.selectedPiece = piece
            
            guard let selectedCell = board.cells.first(where: { $0.node.contains(position) } )?.node else { return }
            
            board.cells.forEach { (cell) in
                let distance = CGPointDistanceSquared(from: selectedCell.position, to: cell.node.position)
                if distance.rounded(.up) == pow(selectedCell.frame.width, 2) && cell.node.zRotation == selectedCell.zRotation {
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
    
    func apply(move: Move) {
        
        let origin = board.cells.first(where: { $0.row == move.from.row && $0.column ==  move.from.column })!
        let destination = board.cells.first(where: { $0.row == move.to.row && $0.column ==  move.to.column })!
        
        let piece = pieces.first(where: { origin.node.contains($0.position) })!
        
        piece.position = destination.node.centroid
        origin.hasPiece = false
        destination.hasPiece = true
        
    }
    
    func move(_ piece: Piece, from origin: Cell, to destination: Cell) {
        piece.position = destination.node.centroid
        origin.hasPiece = false
        destination.hasPiece = true
    }
    
    func clearHighlightedCell() {
        highlightedCells.forEach {
            $0.isHightlighted = false
        }
        highlightedCells.removeAll()
    }
    
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}
