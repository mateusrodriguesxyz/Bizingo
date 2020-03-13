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
    
    var port: Int?
    
    func invite(name: String, onResponse: (Bool) -> ()) {
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        defer {
          try! group.syncShutdownGracefully()
        }

        let configuration = ClientConnection.Configuration(target: .hostAndPort("localhost", port ?? 0), eventLoopGroup: group)

        let connection = ClientConnection(configuration: configuration)

        let service = Bizingo_GameServiceClient(connection: connection)
        
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
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        defer {
          try! group.syncShutdownGracefully()
        }

        let configuration = ClientConnection.Configuration(target: .hostAndPort("localhost", port ?? 0), eventLoopGroup: group)

        let connection = ClientConnection(configuration: configuration)

        let service = Bizingo_GameServiceClient(connection: connection)
        
        let request = Bizingo_StartRequest.with { _ in }

        do {
            let response = try service.start(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func send(_ move: Move, onResponse: (Bool) -> ()) {
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        defer {
          try! group.syncShutdownGracefully()
        }

        let configuration = ClientConnection.Configuration(target: .hostAndPort("localhost", port ?? 0), eventLoopGroup: group)

        let connection = ClientConnection(configuration: configuration)

        let service = Bizingo_GameServiceClient(connection: connection)
        
        let request = Bizingo_MoveRequest.with {
            $0.fromColumn = Int32(move.from.column)
            $0.fromRow = Int32(move.from.row)
            $0.toColumn = Int32(move.to.column)
            $0.toRow = Int32(move.to.row)
        }

        do {
            let response = try service.move(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    
}
