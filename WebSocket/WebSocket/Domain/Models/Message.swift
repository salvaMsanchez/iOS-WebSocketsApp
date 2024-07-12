//
//  Message.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import Foundation

enum MessageType: String, Codable {
    case TEXT
    case IMAGE
}

class Message: Identifiable, Codable {
    let id: UUID
    let type: MessageType
    let message: String
    let airedAt: Date?
    let user: User.Id
    
    init(id: UUID = UUID(), type: MessageType, message: String, airedAt: Date? = Date().currentDate, user: User.Id) {
        self.id = id
        self.type = type
        self.message = message
        self.airedAt = airedAt
        self.user = user
    }
}

// DTOs
extension Message {
    struct Wall: Decodable {
        let id: UUID
        let type: MessageType
        let message: String
        let airedAt: String
        let user: String
    }
    
    struct Server: Encodable {
        let id: UUID
        let type: MessageType
        let message: String
        let airedAt: Date
        let user: String
    }
}
