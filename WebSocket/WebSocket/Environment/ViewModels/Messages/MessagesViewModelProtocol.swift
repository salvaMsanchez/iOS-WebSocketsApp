//
//  MessagesViewModelProtocol.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import Foundation

protocol MessagesViewModelProtocol {
    func initWebSocketConnection()
    func receiveData(onReceiveData: @escaping (Message) -> Void)
//    func fetchMessages(onSuccess: @escaping ([Message]) -> Void, onFailure: @escaping (Error) -> Void)
    func postMessage(message: Message, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func closeWebSocketConnection()
    func uploadImage(type: PhotoType, imageData: Data, onSuccess: @escaping (String) -> Void, onFailure: @escaping (Error) -> Void)
}
