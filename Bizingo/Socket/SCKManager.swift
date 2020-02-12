//
//  SCKManager.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 10/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import SocketIO

class SCKManager: NSObject {
    
    static let shared = SCKManager()
    
    private var manager: SocketManager

    private var socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        self.socket = manager.defaultSocket
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
     
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServer(with nickname: String, completion: @escaping ([Player]?) -> Void) {
        socket.emit("connectUser", nickname)
        socket.on("userList") { (data, _) -> Void in
            let players = (data[0] as? [[String: AnyObject]])?.map({
                Player(nickname: $0["nickname"] as! String, isConnected: $0["isConnected"] as! Bool)
            })
            completion(players)
        }
    }
    
    func exitChat(with nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func send(message: String, with nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    func getChatMessage(completion: @escaping (Message) -> Void) {
        socket.on("newChatMessage") { (data, _) -> Void in
            let message = Message(sender: data[0] as! String, content: data[1] as! String, date: data[2] as! String)
            completion(message)
        }
    }

}
