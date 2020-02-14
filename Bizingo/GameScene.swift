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
    
    var pieces = [SKShapeNode]()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        

        board.cells.forEach { (cell) in
            self.addChild(cell.node)
            if cell.hasPiece {
                let piece = SKShapeNode(circleOfRadius: 10)
                piece.strokeColor = .clear
                piece.fillColor = .orange
                piece.position = cell.node.centroid
                self.pieces.append(piece)
                self.addChild(piece)
            }
        }
        
        do {
            let data = try JSONEncoder().encode(board.cells)
            let string = String(data: data, encoding: .utf8)
            print(string!)
        } catch {
            fatalError()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        guard let node = children.first(where: { $0.contains(position)} ) as? Triangle else { return }
        
//        piece.position = node.centroid
        
        board.cells.forEach { (cell) in
            let distance = CGPointDistanceSquared(from: node.position, to: cell.node.position)
            if distance.rounded(.up) == pow(node.frame.width, 2) && cell.node.zRotation == node.zRotation {
                cell.isHightlighted = true
            } else {
                cell.isHightlighted = false
            }
        }

    }
    
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}
