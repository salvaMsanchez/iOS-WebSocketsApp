//
//  WebSocketManagerProtocol.swift
//  WebSocket
//
//  Created by Salva Moreno on 18/3/24.
//

import Foundation

protocol WebSocketManagerProtocol {
    func initWebSocketConnection()
    func sendMessage(message: Message, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func sendImage(imageData: Data, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func receiveData(onReceiveData: @escaping (Message) -> Void)
    func closeWebSocketConnection()
}
