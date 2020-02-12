//
//  GameViewController.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 31/01/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let skView = SKView()
    
    let uiView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skView)
        view.addSubview(uiView)
        setupSKview()
        setupUIview()
    }
    
    private func setupSKview() {
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        skView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = GameScene(size: CGSize(width: 800, height: 800))
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
    }
    
    private func setupUIview() {
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        uiView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        uiView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        uiView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "players-controller")
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.uiView.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        controller.view.leadingAnchor.constraint(equalTo: uiView.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: uiView.trailingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: uiView.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: uiView.bottomAnchor).isActive = true
        
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
