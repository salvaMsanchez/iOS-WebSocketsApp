//
//  ProfileView.swift
//  WebSocket
//
//  Created by Salva Moreno on 29/3/24.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    // MARK: - Environment -
    @Environment(\.messagesViewModel) private var messagesViewModel: MessagesViewModelProtocol
    
    // MARK: - ViewModel -
    @StateObject private var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    // MARK: - Properties -
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    
    // MARK: - Main -
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gradientBottom, .gradientTop],
                startPoint: .bottom,
                endPoint: .top
            )
            .mask {
                LinearGradient(
                    colors: [.black, .clear],
                    startPoint: .trailing,
                    endPoint: .leading)
            }
            VStack(spacing: 6) {
                Spacer()
                if let image: String = profileViewModel.image {
                    KFImage(URL(string: "http://127.0.0.1:8080\(image)"))
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .cacheOriginalImage()
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    .clipShape(Circle())
                    .scaledToFit()
                    .padding(.vertical, 8)
                    .onTapGesture {
                        isShowingImagePicker = true
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                        changeProfileImage()
                    }) {
                        ImagePicker(image: $selectedImage)
                    }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .background(Color.white)
                        .clipShape(Circle())
                        .scaledToFit()
                        .padding(.vertical, 8)
                        .onTapGesture {
                            isShowingImagePicker = true
                        }
                        .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                            changeProfileImage()
                        }) {
                            ImagePicker(image: $selectedImage)
                        }
                }
                Text(profileViewModel.userName)
                    .bold()
                    .font(.title2)
                Text(profileViewModel.email)
                    .font(.callout)
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            profileViewModel.getEmail()
            profileViewModel.getUserName()
            profileViewModel.getImage()
        }
    }
    
    private func changeProfileImage() {
        guard let selectedImage = selectedImage else { return }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.25) else { return }
        
        messagesViewModel.uploadImage(type: .profile, imageData: imageData) { url in
            print("--- Imagen almacenada ---")
            print("Se recibe url: \(url)")
            
            // Save imageUrl on UserDefaults
            UserDefaults.standard.setValue(url, forKey: Constants.image)
            
            profileViewModel.saveProfileImage(email: profileViewModel.email, imageString: url)
            
            profileViewModel.getImage()
        } onFailure: { error in
            print(error)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
