//
//  DummyMessagesViewModel.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import Foundation

final class DummyMessagesViewModel: MessagesViewModelProtocol {
    
    func initWebSocketConnection() {
        print("--- Dummy WebSocket Connection ---")
    }
    
    func receiveData(onReceiveData: @escaping (Message) -> Void) {
        print("--- Dummy WebSocket Receiving Data ---")
    }
    
//    func fetchMessages(
//        onSuccess: @escaping ([Message]) -> Void,
//        onFailure: @escaping (Error) -> Void
//    ) {
//        let dummyMessages: [Message] = [
//            Message(userName: "Ana", type: .TEXT, message: "¡Hola a todos!"),
//            Message(userName: "Carlos", type: .TEXT, message: "Buenos días, ¿cómo están?"),
//            Message(userName: "María", type: .TEXT, message: "Espero que tengan un excelente día."),
//            Message(userName: "Pedro", type: .IMAGE, message: "https://upload.wikimedia.org/wikipedia/commons/a/aa/Escudo_Granada_club_de_fútbol.png"),
//            Message(userName: "Luisa", type: .TEXT, message: "¡Qué bonita imagen, Pedro!"),
//            Message(userName: "Sofía", type: .TEXT, message: "¿Alguien quiere ir a tomar café?"),
//            Message(userName: "Javier", type: .TEXT, message: "Yo me apunto, Sofía."),
//            Message(userName: "Elena", type: .TEXT, message: "¿A qué hora nos vemos?"),
//            Message(userName: "Andrés", type: .TEXT, message: "Podemos encontrarnos a las 10:00."),
//            Message(userName: "Laura", type: .TEXT, message: "Perfecto, nos vemos allí.")
//        ]
//        onSuccess(dummyMessages)
//    }
    
    func postMessage(
        message: Message,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        onSuccess()
    }
    
    func closeWebSocketConnection() {
        print("--- Dummy WebSocket Closing Connection ---")
    }
    
    func uploadImage(
        type: PhotoType,
        imageData: Data,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        let dummyImageUrl = "https://dummyimage.com/600x400/000/fff"
        onSuccess(dummyImageUrl)
    }
}
