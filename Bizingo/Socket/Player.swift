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
    var name: String
    let number: Int
    let isConnected: Bool
}
