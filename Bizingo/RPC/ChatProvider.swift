//
//  ChatProvider.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation
import GRPC
import NIO

class GameProvider: Bizingo_GameProvider {
    
    var onStart: (() -> ())?
    
    var onEnd: ((String) -> ())?
    
    var onMove: ((Move) -> ())?
    
    var onInvite: ((Move) -> ())?
    
    func move(request: Bizingo_MoveRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_MoveReply> {
        
        if let move = try? JSONDecoder().decode(Move.self, from: request.jsonUTF8Data()) {
            self.onMove?(move)
        }
        
//        let from = Move.Coordinate(row: Int(request.from.row), column: Int(request.from.column))
//        let to = Move.Coordinate(row: Int(request.to.row), column: Int(request.to.column))
//
//        let move = Move(from: from, to: to)
//
        
        let response = Bizingo_MoveReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    
    func start(request: Bizingo_StartRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_StartReply> {
        self.onStart?()
        let response = Bizingo_StartReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func end(request: Bizingo_EndRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_EndReply> {
        let winner = request.winner
        self.onEnd?(winner)
        let response = Bizingo_EndReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    
    func invite(request: Bizingo_InviteRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_InviteReply> {
        let response = Bizingo_InviteReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
}

