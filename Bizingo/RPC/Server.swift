//
//  Server.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation
import GRPC
import NIO
import Logging

class BizingoServer {
    
    var port: Int?
    
    var provider = GameProvider()
    
    func start() {
        
        LoggingSystem.bootstrap {
          var handler = StreamLogHandler.standardOutput(label: $0)
          handler.logLevel = .critical
          return handler
        }

        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        defer {
          try! group.syncShutdownGracefully()
        }

        let configuration = Server.Configuration(target: .hostAndPort("localhost", 0), eventLoopGroup: group, serviceProviders: [provider]
        )

        let server = Server.start(configuration: configuration)
        
        server
            .map {
                $0.channel.localAddress
            }
            .whenSuccess { address in
                self.port = address!.port
                print("server started on port \(address!.port!)")
            }
        
        try? server.flatMap { $0.onClose }.wait()
        
    }
    
}
