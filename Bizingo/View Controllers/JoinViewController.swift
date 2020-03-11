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
        
        RPCManager.shared.onStart = {
            UserDefaults.standard.set(1, forKey: "number")
            NotificationCenter.default.post(name: NSNotification.Name("start_game"), object: nil)
        }
        
//        startButton.isHidden = true
        
        portLabel.text = String(RPCManager.shared.server.port!)
        
    }

    @IBAction func invite(_ sender: UIButton) {
        
        let name = portTextField.text!
        
        guard let port = Int(portTextField.text!) else { return }
        
        RPCManager.shared.client.port = port
        
        RPCManager.shared.client.invite(name: name) { (success) in
            if success {
                UserDefaults.standard.set(name, forKey: "name")
                sender.backgroundColor = .systemGreen
                sender.setTitle("ACCEPTED", for: .normal)
            }
        }
        
        
    }
    @IBAction func start(_ sender: UIButton) {
        
        let name = portTextField.text!
        
        guard let port = Int(portTextField.text!) else { return }
        
        RPCManager.shared.client.port = port
        
        RPCManager.shared.client.start { (success) in
            if success {
                UserDefaults.standard.set(0, forKey: "number")
                NotificationCenter.default.post(name: NSNotification.Name("start_game"), object: nil)
            }
        }
    }
}
