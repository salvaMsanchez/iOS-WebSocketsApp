//
//  Repository.swift
//  WebSocket
//
//  Created by Salva Moreno on 18/3/24.
//

import Foundation

final class Repository: RepositoryProtocol {
    // MARK: - Properties -
    private let webSocketManager: WebSocketManagerProtocol
    private let apiClient: APIClientProtocol
    
    // MARK: - Initializers -
    init(
        webSocketManager: WebSocketManagerProtocol = WebSocketManager(),
        apiClient: APIClientProtocol = APIClient()
    ) {
        self.webSocketManager = webSocketManager
        self.apiClient = apiClient
    }
    
    // MARK: - Functions -
    func initWebSocketConnection() {
        webSocketManager.initWebSocketConnection()
    }
    
    func receiveData(onReceiveData: @escaping (Message) -> Void) {
        webSocketManager.receiveData(onReceiveData: onReceiveData)
    }
    
    func postMessage(
        message: Message,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        webSocketManager.sendMessage(message: message) {
            onSuccess()
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    func closeWebSocketConnection() {
        webSocketManager.closeWebSocketConnection()
    }
    
    func signIn(
        email: String,
        password: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<SessionToken, APIError>) -> Void) {
            apiClient.signIn(email: email, password: password, apiRouter: .signIn) { result in
                switch result {
                    case .success(let sessionToken):
                        completion(.success(sessionToken))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
    func signUp(name: String, email: String, password: String, apiRouter: APIRouter, completion: @escaping (Result<SessionToken, APIError>) -> Void) {
        apiClient.signUp(name: name, email: email, password: password, apiRouter: .signUp) { result in
            switch result {
                case .success(let sessionToken):
                    completion(.success(sessionToken))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getUserId(email: String, apiRouter: APIRouter, completion: @escaping (Result<User.Id, APIError>) -> Void) {
        apiClient.getUserId(email: email, apiRouter: .getUserId) { result in
            switch result {
                case .success(let userId):
                    completion(.success(userId))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getUserInfo(apiRouter: APIRouter, completion: @escaping (Result<User, APIError>) -> Void) {
        apiClient.getUserInfo(apiRouter: apiRouter) { result in
            switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getMessages(apiRouter: APIRouter, completion: @escaping (Result<[Message], APIError>) -> Void) {
        apiClient.getMessages(apiRouter: .getMessages) { result in
            switch result {
                case .success(let messages):
                    completion(.success(messages))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func uploadImage(
        type: PhotoType,
        imageData: Data,
        apiRouter: APIRouter,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        apiClient.uploadImage(type: type, imageData: imageData, apiRouter: .uploadImage) { result in
            switch result {
                case .success(let imageUrl):
                    completion(.success(imageUrl))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func saveProfileImage(
        email: String,
        imageString: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        apiClient.saveProfileImage(email: email, imageString: imageString, apiRouter: .saveProfileImage) { result in
            switch result {
                case .success(let string):
                    completion(.success(string))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func search(
        query: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<[Message], APIError>) -> Void
    ) {
        apiClient.search(query: query, apiRouter: .search) { result in
            switch result {
                case .success(let messages):
                    completion(.success(messages))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
