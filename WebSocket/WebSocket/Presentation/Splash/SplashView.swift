//
//  SplashView.swift
//  WebSocket
//
//  Created by Salva Moreno on 31/3/24.
//

import SwiftUI

struct SplashView: View {
    // MARK: - Properties -
    @EnvironmentObject private var routeViewModel: RouteViewModel
    @EnvironmentObject private var sessionViewModel: SessionViewModel
    
    // MARK: - Main -
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gradientTop, .gradientBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 32)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if sessionViewModel.isValidSession {
                print("Navigate to Tabs")
                routeViewModel.screen = .tabs
            } else {
                print("Navigate to Login")
                routeViewModel.screen = .login
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(RouteViewModel())
            .environmentObject(SessionViewModel())
    }
}
