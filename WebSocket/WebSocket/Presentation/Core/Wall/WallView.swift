//
//  ContentView.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import SwiftUI

struct WallView: View {
    // MARK: - Environment -
    @Environment(\.messagesViewModel) private var messagesViewModel: MessagesViewModelProtocol
    @EnvironmentObject private var routeViewModel: RouteViewModel
    @EnvironmentObject private var sessionViewModel: SessionViewModel
    
    // MARK: - ViewModels -
    @StateObject private var wallViewModel: WallViewModel = WallViewModel()
    
    // MARK: - Properties -
    @State private var message: String = ""
    
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    
    // MARK: - Main -
    var body: some View {
        NavigationStack {
            VStack {
                MessageList(messages: $wallViewModel.messages)
                MessageInput(message: $message, isShowingImagePicker: $isShowingImagePicker, selectedImage: $selectedImage)
            }
            .onAppear(perform: setUp)
            .onDisappear(perform: closeWebSocketConnection)
            .navigationBarItems(trailing: logoutButton)
        }
    }
    
    private func setUp() {
        // Init WebSocket connection
        messagesViewModel.initWebSocketConnection()
        // Set up for receiving data
        messagesViewModel.receiveData { message in
            DispatchQueue.main.async {
                wallViewModel.messages.insert(message, at: 0)
            }
        }
        // Fetch user info from server
        if let userId = UserDefaults.standard.object(forKey: Constants.userId) as? String {
            wallViewModel.fetchUserInfo(userId: userId) { success in
                if success {
                    // Fetch messages from server
                    wallViewModel.fetchMessages()
                }
            }
        }
    }
    
    private func closeWebSocketConnection() {
        messagesViewModel.closeWebSocketConnection()
    }
    
    private var logoutButton: some View {
        Button(action: {
            sessionViewModel.logOut()
            routeViewModel.screen = .login
        }) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .foregroundColor(.black)
        }
    }
}

struct WallView_Previews: PreviewProvider {
    static var previews: some View {
        WallView()
    }
}
