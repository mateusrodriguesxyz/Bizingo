//
//  JoinViewController.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {

    @IBOutlet weak var portLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        RPCManager.shared.run { (port) in
            DispatchQueue.main.async {
                self.portLabel.text = String(port)
            }
        }
        
        RPCManager.shared.onStart {
            UserDefaults.standard.set(1, forKey: "number")
            self.start()
        }
        
    }

    @IBAction func invite(_ sender: UIButton) {
        
        let name = portTextField.text!
        
        guard let port = Int(portTextField.text!) else { return }
        
        RPCManager.shared.client.port = port
        
        RPCManager.shared.client.invite(name: name) { (success) in
            if success {
                UserDefaults.standard.set(name, forKey: "name")
                nameTextField.isEnabled = false
                portTextField.isEnabled = false
                sender.backgroundColor = .systemGreen
                sender.setTitle("CONNECTED", for: .normal)
            }
        }    
        
    }
    
    @IBAction func start(_ sender: UIButton) {
        RPCManager.shared.client.start { (success) in
            if success {
                UserDefaults.standard.set(0, forKey: "number")
                self.start()
            }
        }
    }
    
    private func start() {
        DispatchQueue.main.async {
            
            self.startButton.isEnabled = false
            self.startButton.alpha = 0.5
            
            NotificationCenter.default.post(name: .start, object: nil)
            
            let chat = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chat-controller") as! ChatViewController
            
            chat.view.frame = self.view.bounds
            self.view.addSubview(chat.view)
            
            UIView.transition(from: self.view, to: chat.view, duration: 0.25, options: .transitionCrossDissolve) { _ in
                chat.didMove(toParent: self)
            }
            
        }
    }
    
}
