//
//  RouteViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 19/3/24.
//

import Foundation

final class RouteViewModel: ObservableObject {
    @Published var screen: RoutingStatus.Screen = .splash
    @Published var tab: RoutingStatus.Tab = .wall
}
