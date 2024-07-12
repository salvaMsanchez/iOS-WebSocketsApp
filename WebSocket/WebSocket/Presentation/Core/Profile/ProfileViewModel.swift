//
//  ProfileViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 4/4/24.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    // MARK: - Properties -
    private let repository: RepositoryProtocol
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
    func getUserName() {
        DispatchQueue.global().async {
            if let userName: String = UserDefaults.standard.object(forKey: Constants.userName) as? String {
                DispatchQueue.main.async {
                    self.userName = userName
                }
            }
        }
    }
    
    func getEmail() {
        DispatchQueue.global().async {
            if let email: String = UserDefaults.standard.object(forKey: Constants.email) as? String {
                DispatchQueue.main.async {
                    self.email = email
                }
            }
        }
    }
    
    func getImage() {
        DispatchQueue.global().async {
            if let image: String = UserDefaults.standard.object(forKey: Constants.image) as? String {
                if !image.isEmpty {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
    
    func saveProfileImage(email: String, imageString: String) {
        DispatchQueue.global().async { [weak self] in
            self?.repository.saveProfileImage(email: email, imageString: imageString, apiRouter: .saveProfileImage) { result in
                switch result {
                    case .success(let response):
                        print(response)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
