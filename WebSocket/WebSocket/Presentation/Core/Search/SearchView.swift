//
//  SearchView.swift
//  WebSocket
//
//  Created by Salva Moreno on 19/3/24.
//

import SwiftUI

struct SearchView: View {
    // MARK: - Properties -
    @State private var searchTerm: String = ""
    @StateObject var searchViewModel: SearchViewModel
    
    // MARK: - Main -
    var body: some View {
        NavigationStack {
            MessageList(messages: $searchViewModel.messages)
        }
        .navigationTitle("Search")
        .onChange(of: searchTerm, perform: { newValue in
            updateSearchResults(searchTerm: newValue)
        })
        .searchable(text: $searchTerm, prompt: "Search Messages")
    }
    
    func updateSearchResults(searchTerm: String) {
        let term: String = searchTerm.trimmingCharacters(in: .whitespaces)
        if !term.isEmpty, term.count >= 3 {
            searchViewModel.search(query: term)
        } else {
            searchViewModel.onSearchEmpty()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchViewModel: SearchViewModel())
    }
}
