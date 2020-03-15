//
//  ChatViewController.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 10/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    let player = UserDefaults.standard.integer(forKey: "number")
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "message-cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RPCManager.shared.onMessage { (message) in
            self.messages.append(message)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func send(_ sender: Any) {
        if !textField.text!.isEmpty, let content = textField.text {
            let message = Message(sender: player, content: content)
            RPCManager.shared.client.send(message) { _ in
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            textField.text = nil
            textField.resignFirstResponder()
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message-cell") as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.content
        
        cell.balloonView.backgroundColor = message.sender == 0 ? .systemBlue : .systemRed
        
        if message.sender == player {
            cell.leadingConstraint.isActive = false
            cell.trailingConstraint.isActive = true
        } else {
            cell.leadingConstraint.isActive = true
            cell.trailingConstraint.isActive = false
        }
        
        return cell
    }
    
    
}
