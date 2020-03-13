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
    func move(request: Bizingo_MoveRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_MoveReply> {
        let from = Move.Coordinate(row: Int(request.fromRow), column: Int(request.fromColumn))
        let to = Move.Coordinate(row: Int(request.toRow), column: Int(request.toColumn))
        let move = Move(from: from, to: to)
        RPCManager.shared.onMove?(move)
        let response = Bizingo_MoveReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    
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

