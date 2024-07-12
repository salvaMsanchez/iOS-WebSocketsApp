//
//  SessionViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 30/3/24.
//

import SwiftUI

final class SessionViewModel: ObservableObject {
    // MARK: - Properties -
    @Published var isLoading = false
    @Published var isValidSession = false
    
    private let repository: RepositoryProtocol
    
    // MARK: - Initializers -
    init(
        repository: RepositoryProtocol = Repository()
    ) {
        self.repository = repository
        checkSession()
    }
    
    // MARK: - Functions -
    private func checkSession() {
        guard let _ = UserDefaults.standard.object(forKey: Constants.accessToken) else {
            isValidSession = false
            return
        }
        
        isValidSession = true
    }
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            defer { self?.isLoading = false }
            
            DispatchQueue.global().async { [weak self] in
                self?.repository.signIn(email: email, password: password, apiRouter: .signIn) { result in
                    switch result {
                        case .success(let sessionToken):
                            UserDefaults.standard.setValue(sessionToken.accessToken, forKey: Constants.accessToken)
                            
                            completion(.success(sessionToken.accessToken))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func signUp(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            defer { self?.isLoading = false }
            
            DispatchQueue.global().async { [weak self] in
                self?.repository.signUp(name: name, email: email, password: password, apiRouter: .signUp) { result in
                    switch result {
                        case .success(let sessionToken):
                            UserDefaults.standard.setValue(sessionToken.accessToken, forKey: Constants.accessToken)
                            
                            completion(.success(sessionToken.accessToken))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getUserId(
        email: String,
        completion: @escaping (Result<User.Id, APIError>) -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            defer { self?.isLoading = false }
            
            DispatchQueue.global().async { [weak self] in
                self?.repository.getUserId(email: email, apiRouter: .getUserId, completion: { result in
                    switch result {
                        case .success(let userId):
                            completion(.success(userId))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                })
            }
        }
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.userId)
        UserDefaults.standard.removeObject(forKey: Constants.email)
        UserDefaults.standard.removeObject(forKey: Constants.image)
        
//        if let accessToken = UserDefaults.standard.object(forKey: Constants.accessToken) {
//            print(accessToken)
//        } else {
//            print("---- ACCESS TOKEN ELIMINADO ---")
//            print("---- LOG OUT ---")
//            print("---- ... ---")
//        }
    }
}
