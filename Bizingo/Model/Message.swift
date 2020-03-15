//
//  Message.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 11/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    var sender: Int
    var content: String
    
    init(sender: Int, content: String) {
        self.sender = sender
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sender = try values.decodeIfPresent(Int.self, forKey: .sender) ?? 0
        content = try values.decode(String.self, forKey: .content)
    }
    
    enum CodingKeys: String, CodingKey {
        case sender
        case content
    }
    
}
