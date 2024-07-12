//
//  Message.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import SwiftUI

struct MessageInput: View {
    // MARK: - Environment -
    @Environment(\.messagesViewModel) private var messagesViewModel: MessagesViewModelProtocol
    
    // MARK: - Properties -
    @Binding var message: String
    @Binding var isShowingImagePicker: Bool
    @Binding var selectedImage: UIImage?
    
    // MARK: - Main -
    var body: some View {
        VStack {
            TextField("Escribe tu mensaje...", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button(action: {
                    sendTextMessage()
                }) {
                    Text("Enviar mensaje")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.trailing)

                Button(action: {
                    isShowingImagePicker = true
                }) {
                    Text("Enviar imagen")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                    sendImageMessage()
                }) {
                    ImagePicker(image: $selectedImage)
                }
            }
            .padding(.bottom)
        }
    }
    
    private func sendTextMessage() {
        guard let userId: String = UserDefaults.standard.object(forKey: Constants.userId) as? String else { return }
        
        let message: Message = .init(type: .TEXT, message: self.message, user: User.Id(id: userId))
        
        messagesViewModel.postMessage(message: message) {
            self.message = ""
            print("--- Mensaje enviado ---")
        } onFailure: { error in
            print(error)
        }
    }

    private func sendImageMessage() {
        guard let selectedImage = selectedImage else { return }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.25) else { return }
        
        messagesViewModel.uploadImage(type: .wall, imageData: imageData) { url in
            guard let userId: String = UserDefaults.standard.object(forKey: Constants.userId) as? String else { return }
            
            let message: Message = .init(type: .IMAGE, message: url, user: User.Id(id: userId))
            
            messagesViewModel.postMessage(message: message) {
                print("--- Imagen enviada ---")
            } onFailure: { error in
                print(error)
            }
        } onFailure: { error in
            print(error)
        }
    }
}

struct MessageInput_Previews: PreviewProvider {
    static var previews: some View {
        let message = Binding.constant("Hola")
        let isShowingImagePicker = Binding.constant(false)
        let selectedImage = Binding<UIImage?>(
            get: { nil },
            set: { _ in }
        )
        
        return MessageInput(
            message: message,
            isShowingImagePicker: isShowingImagePicker,
            selectedImage: selectedImage
        )
    }
}
