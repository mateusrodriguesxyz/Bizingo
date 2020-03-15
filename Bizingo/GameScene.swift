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
    
    let restartLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: "AvenirNext-Bold")
        node.text = "RESTART"
        node.fontSize = 50
        node.horizontalAlignmentMode = .left
        return node
    }()
    
    let quitLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: "AvenirNext-Bold")
        node.text = "QUIT"
        node.fontSize = 50
        node.horizontalAlignmentMode = .left
        return node
    }()
    
    let winnerLabel = SKLabelNode()
    
    var board: Board!
    
    var blue = 18 {
        didSet {
            if blue == 0, player.number == 0 {
                self.end()
            }
        }
    }

    var red = 18 {
        didSet {
            if red == 0, player.number == 1 {
                self.end()
            }
        }
    }
    
    var selectedPiece: Piece! = nil
    
    var highlightedCells: [Cell] = []
    
    var player: Player!
    
    var canPlay: Bool!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: .start, object: nil)
        
        RPCManager.shared.onRestart {
            self.start()
        }
        
        RPCManager.shared.onEnd { (winner) in
            self.winnerLabel.text = "YOU LOST THE GAME!"
        }
        
        RPCManager.shared.onQuit {
            self.removeAllChildren()
            NotificationCenter.default.post(name: .quit, object: nil)
        }
        
        RPCManager.shared.onMove {
            self.apply(move: $0)
        }
        
    }
    
    func initialSetup() {
        
        removeAllChildren()
        
        winnerLabel.position = CGPoint(x: frame.midX, y: frame.maxY/1.25)
        addChild(winnerLabel)

        restartLabel.position = CGPoint(x: frame.minX/1.1, y: frame.maxY/1.25)
        addChild(restartLabel)

        quitLabel.position = CGPoint(x: frame.minX/1.1, y: frame.maxY/1.5)
        addChild(quitLabel)
        
        board = Board(contentsOf: Bundle.main.url(forResource: "board", withExtension: "json")!)!
        
        blue = 18
        red = 18

        board.placeCells(at: self)
    }
    
    @objc func start() {
        let name = UserDefaults.standard.string(forKey: "name")!
        let number = UserDefaults.standard.integer(forKey: "number")
        self.player = Player(name: name, number: number, isConnected: true)
        self.initialSetup()
        self.canPlay = true
        self.board.placePieces(at: self)
    }
    
    func end() {
        RPCManager.shared.client.end { (success) in
            self.winnerLabel.text = "YOU WON THE GAME!"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        if self.nodes(at: position).first == restartLabel {
            RPCManager.shared.client.restart { (success) in
                self.start()
            }
            return
        }
        
        if self.nodes(at: position).first == quitLabel {
            RPCManager.shared.client.quit { (success) in
                self.removeAllChildren()
                NotificationCenter.default.post(name: .quit, object: nil)
            }
            return
        }
        
        guard canPlay == true else { return }
        
        if selectedPiece != nil {
            if let destination = highlightedCells.first(where: { $0.node.contains(position)} ) {
                let origin = board.cell(at: selectedPiece.position)
                let move = Move(from: origin!, to: destination)
                RPCManager.shared.client.send(move) { (success) in
                    self.apply(move: move)
                }
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
                
                if piece.isCaptain {
                    let pieces = enemies.compactMap({ self.board.piece(at: $0.position) })
                    guard pieces.contains(where: { $0.isCaptain }) else { return }
                }
                
                cell.hasPiece = false
                piece.removeFromParent()
                
                if piece.fillColor.description == UIColor.systemRed.resolvedColor(with: .current).description {
                    red -= 1
                }
                if piece.fillColor.description == UIColor.systemBlue.resolvedColor(with: .current).description {
                    blue -= 1
                }
                
                board.pieces.remove(at: i)
                
            }
            
        }
        
    }
    
}
