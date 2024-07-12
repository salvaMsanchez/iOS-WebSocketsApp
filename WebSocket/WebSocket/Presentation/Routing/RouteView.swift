//
//  RouteView.swift
//  WebSocket
//
//  Created by Salva Moreno on 19/3/24.
//

import SwiftUI

struct RouteView: View {
    // MARK: - Properties -
    @EnvironmentObject private var routeViewModel: RouteViewModel
    
    // MARK: - Main -
    var body: some View {
        switch routeViewModel.screen {
            case .splash:
                SplashView()
            case .login:
                SignInView()
            case .tabs:
                TabsView()
        }
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}
