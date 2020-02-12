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
    
    let board = Board()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        board.cells.forEach { (cell) in
            self.addChild(cell.node)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        guard let node = children.first(where: { $0.contains(position)} ) as? Triangle else { return }
        
        let piece = SKShapeNode(circleOfRadius: 10)
        
        piece.position = node.centroid
        
        piece.strokeColor = .clear
        piece.fillColor = .orange
        
        self.addChild(piece)
        
        board.cells.forEach { (cell) in
            let distance = CGPointDistanceSquared(from: node.position, to: cell.node.position)
            if distance.rounded(.up) == pow(node.frame.width, 2) && cell.node.fillColor == node.fillColor {
                cell.isHightlighted = true
            } else {
                cell.isHightlighted = false
            }
        }

        node.fillColor = .white
        
    }
    
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}
