//
//  WebSocketApp.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import SwiftUI

@main
struct WebSocketApp: App {
    // MARK: - Properties
    @StateObject var routeViewModel = RouteViewModel()
    @StateObject var sessionViewModel = SessionViewModel()
    
    var body: some Scene {
        WindowGroup {
            RouteView()
                .environmentObject(routeViewModel)
                .environmentObject(sessionViewModel)
        }
    }
}
