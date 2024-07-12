//
//  VaporMessagesViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 15/3/24.
//

import Foundation

final class VaporMessagesViewModel: MessagesViewModelProtocol {
    // MARK: - Properties -
    private let repository: RepositoryProtocol
    
    // MARK: - Initializers -
    init(
        repository: RepositoryProtocol = Repository()
    ) {
        self.repository = repository
    }
    
    // MARK: - Functions -
    func initWebSocketConnection() {
        repository.initWebSocketConnection()
    }
    
    func receiveData(onReceiveData: @escaping (Message) -> Void) {
        repository.receiveData(onReceiveData: onReceiveData)
    }
    
    func postMessage(
        message: Message,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        repository.postMessage(message: message) {
            onSuccess()
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    func closeWebSocketConnection() {
        repository.closeWebSocketConnection()
    }
    
    func uploadImage(
        type: PhotoType,
        imageData: Data,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            self?.repository.uploadImage(type: type, imageData: imageData, apiRouter: .uploadImage) { result in
                switch result {
                    case .success(let imageUrl):
                        onSuccess(imageUrl)
                    case .failure(let error):
                        onFailure(error)
                }
            }
        }
    }
}
