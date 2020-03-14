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

    private init() {}
    
    public func run(handler: @escaping (Int) -> ()) {
        server.onRun = handler
        DispatchQueue.global().async {
            self.server.run()
        }
    }
    
    public func onStart(handler: @escaping () -> ()) {
        server.provider.onStart = handler
    }
    
    public func onMove(handler: @escaping (Move) -> ()) {
        server.provider.onMove = handler
    }
    
}
