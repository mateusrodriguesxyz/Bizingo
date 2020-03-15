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
    
    func restart(onResponse: (Bool) -> ()) {
        
        let request = Bizingo_RestartRequest.with { _ in }

        do {
            let response = try service.restart(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func end(onResponse: (Bool) -> ()) {
        
        let request = Bizingo_EndRequest.with {
            $0.winner = UserDefaults.standard.string(forKey: "name")!
        }

        do {
            let response = try service.end(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func quit(onResponse: (Bool) -> ()) {
        
        let request = Bizingo_QuitRequest.with { _ in }

        do {
            let response = try service.quit(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
        
    }
    
    func send(_ move: Move, onResponse: (Bool) -> ()) {
        do {
            let data = try JSONEncoder().encode(move)
            let request = try Bizingo_MoveRequest(jsonUTF8Data: data)
            let response = try service.move(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
    }
    
    func send(_ message: Message, onResponse: (Bool) -> ()) {
        do {
            let data = try JSONEncoder().encode(message)
            let request = try Bizingo_MessageRequest(jsonUTF8Data: data)
            let response = try service.message(request).response.wait()
            onResponse(response.success)
        } catch {
            print("Failed: \(error)")
        }
    }
    
    
}
