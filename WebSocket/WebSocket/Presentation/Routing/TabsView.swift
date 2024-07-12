//
//  TabsView.swift
//  WebSocket
//
//  Created by Salva Moreno on 19/3/24.
//

import SwiftUI

struct TabsView: View {
    // MARK: - Properties -
    @EnvironmentObject private var routeViewModel: RouteViewModel
    
    // MARK: - Main -
    var body: some View {
        TabView(selection: $routeViewModel.tab) {
            WallView()
                .tabItem {
                    Label(
                        "tab_wall",
                        systemImage: Image.Symbol.person3Fill.rawValue
                    )
                }
                .tag(RoutingStatus.Tab.wall)
            
            SearchView(searchViewModel: SearchViewModel())
                .tabItem {
                    Label(
                        "tab_search",
                        systemImage: Image.Symbol.magnifyingglass.rawValue
                    )
                }
                .tag(RoutingStatus.Tab.search)
            
            ProfileView()
                .tabItem {
                    Label(
                        "tab_profile",
                        systemImage: Image.Symbol.personCircleFill.rawValue
                    )
                }
                .tag(RoutingStatus.Tab.profile)
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
