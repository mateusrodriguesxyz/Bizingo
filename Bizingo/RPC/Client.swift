//
//  Client.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation
import GRPC
import NIO
import Logging

class BizingoClient {
    
    var port: Int!
    
    private var group: MultiThreadedEventLoopGroup!
    
    lazy var service: Bizingo_GameServiceClient = {
        let target = ConnectionTarget.hostAndPort("localhost", port)
        let configuration = ClientConnection.Configuration(target: target, eventLoopGroup: group)
        let connection = ClientConnection(configuration: configuration)
        return Bizingo_GameServiceClient(connection: connection)
    }()
    
    init() {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    deinit {
        do {
            try group.syncShutdownGracefully()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func invite(name: String, onResponse: (Bool) -> ()) {

        let request = Bizingo_InviteRequest.with {
              $0.name = name
          }

        do {
            let response = try service.invite(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func start(onResponse: (Bool) -> ()) {
        
        let request = Bizingo_StartRequest.with { _ in }

        do {
            let response = try service.start(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func send(_ move: Move, onResponse: (Bool) -> ()) {
        
        let request = Bizingo_MoveRequest.with {
            $0.from.row = Int32(move.from.row)
            $0.from.column = Int32(move.from.column)
            $0.to.row = Int32(move.to.row)
            $0.to.column = Int32(move.to.column)
        }

        do {
            let response = try service.move(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    
}
