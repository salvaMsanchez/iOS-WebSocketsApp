//
//  MessagesViewModelEnviromentKet.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import SwiftUI

struct MessagesViewModelEnviromentKey: EnvironmentKey {
    static let defaultValue: MessagesViewModelProtocol = VaporMessagesViewModel()
}

extension EnvironmentValues {
    var messagesViewModel: MessagesViewModelProtocol {
        get { self[MessagesViewModelEnviromentKey.self] }
        set { self[MessagesViewModelEnviromentKey.self] = newValue }
    }
}
