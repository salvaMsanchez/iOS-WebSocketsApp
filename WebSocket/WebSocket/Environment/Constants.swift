//
//  Constants.swift
//  WebSocket
//
//  Created by Salva Moreno on 1/4/24.
//

import Foundation

// MARK: - Constants -
#warning("CAMBIAR A FUTURO - Evitar tener la apiKey en plano - Para proyecto personal podemos hacer un endpoint que la devuelva al iniciar la app y se guarde en Keychain en la parte de cliente")
struct Constants {
    // General
    static let accessToken = "accessToken"
    static let userName = "userName"
    static let email = "email"
    static let image = "image"
    static let userId = "userId"
    
    // API
    static let host = "127.0.0.1"
    static let port = 8080
    static let scheme = "http"
    static let get = "GET"
    static let post = "POST"
    static let api = "/api/v1"
    static let apikey = ""
}
