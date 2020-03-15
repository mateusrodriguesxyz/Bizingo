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
    
    var onInvite: (() -> ())?
    
    var onStart: (() -> ())?
    
    var onRestart: (() -> ())?
    
    var onEnd: ((String) -> ())?
    
    var onQuit: (() -> ())?
    
    var onMove: ((Move) -> ())?
    
    var onMessage: ((Message) -> ())?
    
    func move(request: Bizingo_MoveRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_MoveReply> {
        if let move = try? JSONDecoder().decode(Move.self, from: request.jsonUTF8Data()) {
            self.onMove?(move)
        }
        let response = Bizingo_MoveReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func message(request: Bizingo_MessageRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_MessageReply> {
        if let message = try? JSONDecoder().decode(Message.self, from: request.jsonUTF8Data()) {
            self.onMessage?(message)
        }
        let response = Bizingo_MessageReply.with {
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
    
    func start(request: Bizingo_StartRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_StartReply> {
        self.onStart?()
        let response = Bizingo_StartReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func restart(request: Bizingo_RestartRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_RestartReply> {
        self.onRestart?()
        let response = Bizingo_RestartReply.with {
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
    
    func quit(request: Bizingo_QuitRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Bizingo_QuitReply> {
        self.onQuit?()
        let response = Bizingo_QuitReply.with {
            $0.success = true
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
    
}

