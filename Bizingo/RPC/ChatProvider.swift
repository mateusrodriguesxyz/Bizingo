//
//  ChatProvider.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import GRPC
import NIO

class GameProvider: Bizingo_GameProvider {
    
    func start(request: Bizingo_StartRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_StartReply> {
        RPCManager.shared.onStart?()
        let response = Bizingo_StartReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    
    func invite(request: Bizingo_InviteRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_InviteReply> {
        RPCManager.shared.hasOpponent = true
        let response = Bizingo_InviteReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
}

