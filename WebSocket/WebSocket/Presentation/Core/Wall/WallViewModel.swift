//
//  WallViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 31/3/24.
//

import Foundation

final class WallViewModel: ObservableObject {
    // MARK: - Properties -
    private let repository: RepositoryProtocol
    
    @Published var isLoading = false
    @Published var messages = [Message]()
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var image: String? = nil
    
    // MARK: - Initializers -
    init(
        repository: RepositoryProtocol = Repository()
    ) {
        self.repository = repository
    }
    
    // MARK: - Functions -
    func fetchUserInfo(userId: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.repository.getUserInfo(apiRouter: .getUserInfo(id: userId), completion: { result in
                switch result {
                    case .success(let user):
                        UserDefaults.standard.set(user.userName, forKey: Constants.userName)
                        UserDefaults.standard.set(user.email, forKey: Constants.email)
                        if let image = user.image {
                            UserDefaults.standard.set(image, forKey: Constants.image)
                        } else {
                            UserDefaults.standard.set("", forKey: Constants.image)
                        }
                        completion(true)
                    case .failure(let error):
                        print(error)
                        completion(false)
                }
            })
        }
    }
    
    func fetchUserMessageInfo(userId: String) {
        DispatchQueue.global().async { [weak self] in
            self?.repository.getUserInfo(apiRouter: .getUserInfo(id: userId), completion: { result in
                switch result {
                    case .success(let user):
                        DispatchQueue.main.async { [weak self] in
                            self?.userName = user.userName
                            self?.email = user.email
                        }
                        if let image = user.image {
                            DispatchQueue.main.async { [weak self] in
                                self?.image = image
                            }
                        }
                    case .failure(let error):
                        print(error)
                }
            })
        }
    }
    
    func fetchMessages() {
        DispatchQueue.global().async { [weak self] in
            self?.repository.getMessages(apiRouter: .getMessages) { result in
                switch result {
                    case .success(let messages):
                        DispatchQueue.main.async { [weak self] in
                            self?.messages = messages
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
