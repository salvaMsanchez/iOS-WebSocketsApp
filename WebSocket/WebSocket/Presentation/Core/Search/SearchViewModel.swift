//
//  SearchViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 28/3/24.
//

import Foundation

final class SearchViewModel: ObservableObject {
    // MARK: - Properties -
    @Published var messages: [Message] = []
    private let repository: RepositoryProtocol
    
    // MARK: - Init -
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    // MARK: - Functions -
    func search(query: String) {
        DispatchQueue.global().async { [weak self] in
            self?.repository.search(query: query, apiRouter: .search) { result in
                switch result {
                    case .success(let messages):
                        DispatchQueue.main.async {
                            self?.messages = messages
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func onSearchEmpty() {
        messages = []
    }
}
