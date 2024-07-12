//
//  User.swift
//  WebSocket
//
//  Created by Salva Moreno on 7/4/24.
//

import Foundation

struct User: Codable {
    let userName: String
    let email: String
    let image: String?
}

extension User {
    struct Id: Codable {
        let id: String
    }
}
