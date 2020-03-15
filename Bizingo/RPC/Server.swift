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
    
    var isRunning = false
    
    var provider = GameProvider()
    
    var onRun: ((Int) -> ())?
    
    func run() {
        
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
                if let port = address?.port {
                    self.port = port
                    self.isRunning = true
                    self.onRun?(port)
                    print("server started on port \(port)")
                }
            }
        
        try? server.flatMap { $0.onClose }.wait()
        
    }
    
}
