//
//  MessageList.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import SwiftUI

struct MessageList: View {
    @Binding var messages: [Message]
    
    var body: some View {
        List(messages, id: \.id) { message in
            MessageRow(message: message)
        }
        .navigationTitle("Messages")
        .padding(.bottom)
    }
}

struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        let message1: Message = .init(type: .TEXT, message: "Mensaje de Pepe", user: User.Id(id: "12345"))
        let message2: Message = .init(type: .TEXT, message: "Mensaje de Juana", user: User.Id(id: "12345"))
        let messages = Binding.constant([message1, message2])
        
        MessageList(messages: messages)
    }
}
