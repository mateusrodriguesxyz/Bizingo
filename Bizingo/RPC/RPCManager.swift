//
//  RPCManager.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation
import CloudKit

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
    
    public func onEnd(handler: @escaping (String) -> ()) {
        server.provider.onEnd = handler
    }
    
    public func onMove(handler: @escaping (Move) -> ()) {
        server.provider.onMove = handler
    }
    
    public func onMessage(handler: @escaping (Message) -> ()) {
        server.provider.onMessage = handler
    }
    
}
