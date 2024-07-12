//
//  RoutingStatus.swift
//  WebSocket
//
//  Created by Salva Moreno on 19/3/24.
//

import Foundation

struct RoutingStatus {
    enum Screen {
        case splash
        case login
        case tabs
    }

    enum Tab {
        case wall
        case search
        case profile
    }
}
