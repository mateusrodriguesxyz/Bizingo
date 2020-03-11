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
    
    
}
