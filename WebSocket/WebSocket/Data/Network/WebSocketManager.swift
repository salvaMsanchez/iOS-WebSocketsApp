//
//  WebSocketManager.swift
//  WebSocket
//
//  Created by Salva Moreno on 15/3/24.
//

import Foundation

final class WebSocketManager: WebSocketManagerProtocol {
    // MARK: - Properties -
    private var webSocketTask: URLSessionWebSocketTask!
    
    // MARK: - Functions -
    func initWebSocketConnection() {
        // URL del servidor WebSocket
        let url = URL(string: "ws://127.0.0.1:8080/wall")!
        
        // Crear una sesión URLSession
        let session = URLSession(configuration: .default)
        
        // Crear la tarea WebSocket
        webSocketTask = session.webSocketTask(with: url)
        
        // Iniciar la conexión
        webSocketTask.resume()
    }
    
    func sendMessage(message: Message, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        do {
            if let airedAt = message.airedAt {
                let serverMessage: Message.Server = .init(id: message.id, type: message.type, message: message.message, airedAt: airedAt, user: message.user.id)
                
                let encoder = JSONEncoder()
                let messageData = try encoder.encode(serverMessage)
                
                webSocketTask.send(.data(messageData)) { error in
                    if let error {
                        print(error)
                        onFailure(error)
                    }
                }
                onSuccess()
            } else {
                let serverMessage: Message.Server = .init(id: message.id, type: message.type, message: message.message, airedAt: Date().currentDate, user: message.user.id)
                
                let encoder = JSONEncoder()
                let messageData = try encoder.encode(serverMessage)
                
                webSocketTask.send(.data(messageData)) { error in
                    if let error {
                        print(error)
                        onFailure(error)
                    }
                }
                onSuccess()
            }
        } catch {
            print("Error al convertir a Data: \(error)")
            onFailure(error)
        }
    }
    
    func sendImage(imageData: Data, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        webSocketTask.send(.data(imageData)) { error in
            if let error {
                print(error)
                onFailure(error)
            }
        }
        onSuccess()
    }
    
    func receiveData(onReceiveData: @escaping (Message) -> Void) {
        webSocketTask.receive { result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let message):
                    switch message {
                        case .string(let text):
                            print("Received text message: \(text)")
                        case .data(let data):
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(Message.self, from: data)
                                
                                onReceiveData(decodedData)
                            } catch {
                                print("Error al decodificar el mensaje recibido de backend. Error: \(error)")
                            }
                        @unknown default:
                            fatalError()
                    }
                    
                    self.receiveData(onReceiveData: onReceiveData)
            }
        }
    }
    
    func closeWebSocketConnection() {
        webSocketTask.cancel(with: .goingAway, reason: .empty)
    }
}
