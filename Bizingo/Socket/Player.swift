//
//  Player.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 10/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct Player: Hashable {
    
    let identifier = UUID()
    var number: Int
    let nickname: String
    let isConnected: Bool
    
    init(data: [String: AnyObject]) {
        self.number = data["number"] as! Int
        self.nickname = data["nickname"] as! String
        self.isConnected = data["isConnected"] as! Bool
    }
    
}
