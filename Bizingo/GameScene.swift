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

    var red = 18
    var blue = 18
    
    var selectedPiece: Piece! = nil
    
    var highlightedCells: [Cell] = []
    
    var nickname: String {
        return UserDefaults.standard.string(forKey: "nickname")!
    }
    
    var player: Player!
    
    var canPlay: Bool!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        board.placeNodes(at: self)
        
        SCKManager.shared.socket.on("userConnectUpdate") { (data, _) in
            let player = Player(data: data[0] as! [String : AnyObject])
            if player.nickname == self.nickname {
                self.player = player
                self.canPlay = player.number == 0
            }
        }
        
        SCKManager.shared.getGameMovement { (move) in
            if let move = move {
                self.canPlay.toggle()
                self.apply(move: move)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard canPlay == true else { return }
        
        guard let position = touches.first?.location(in: self) else { return }
        
        if selectedPiece != nil {
            if let destination = highlightedCells.first(where: { $0.node.contains(position)} ) {
                let origin = board.cell(at: selectedPiece.position)
                SCKManager.shared.send(movement: .init(nickname: nickname, from: origin!, to: destination))
                selectedPiece = nil
                clearHighlightedCell()
            }   
        } else {
            guard let piece = board.piece(at: position) else { return }
            guard piece.number == player.number else { return }
            self.selectedPiece = piece
            let selectedCell = board.cell(at: position)!
            selectedCell.neighbors.forEach { (cell) in
                if !cell.hasPiece && cell.color == selectedCell.color {
                    cell.isHightlighted = true
                    self.highlightedCells.append(cell)
                } else {
                    cell.isHightlighted = false
                }
            }
            
        }

    }
    
    func apply(move: Move) {
        
        let origin = board.cells.first(where: { $0.row == move.from.row && $0.column ==  move.from.column })!
        let destination = board.cells.first(where: { $0.row == move.to.row && $0.column ==  move.to.column })!
        
        let piece = board.piece(at: origin.node.position)!
        
        piece.position = destination.node.centroid
        
        origin.hasPiece = false
        destination.hasPiece = true
        
        checkPieces()
        
    }
    
    func clearHighlightedCell() {
        highlightedCells.forEach { $0.isHightlighted = false }
        highlightedCells.removeAll()
    }
    
    func checkPieces() {

        for (i, piece) in board.pieces.enumerated().reversed() {
            
            let cell = board.cells.first(where: { $0.node.contains(piece.position) })!
            
            let enemies = cell.neighbors.filter({ $0.color != cell.color })
            
            if enemies.allSatisfy({ $0.hasPiece }) {
                cell.hasPiece = false
                piece.removeFromParent()
                
                if piece.fillColor.description == UIColor.systemRed.resolvedColor(with: .current).description {
                    red -= 1
                }
                if piece.fillColor.description == UIColor.systemBlue.resolvedColor(with: .current).description {
                    blue -= 1
                }
                
                board.pieces.remove(at: i)
                
                if red == 0 {
                   print("BLUE WON!")
                }
                
                if blue == 0 {
                   print("RED WON!")
                }
                
            }
            
        }
        
    }
    
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}
