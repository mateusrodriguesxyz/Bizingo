//
//  RPCManager.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

class RPCManager {
    
    static var shared = RPCManager()
    
    var client = BizingoClient()
    var server = BizingoServer()
    
    var hasOpponent = false
    
    var onStart: (() -> ())?
    
    private init() {} 
    
}