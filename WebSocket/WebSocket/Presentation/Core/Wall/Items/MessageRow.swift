//
//  MessageRow.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import SwiftUI
import Kingfisher

struct MessageRow: View {
    // MARK: - Properties -
    var message: Message
    
    // MARK: - ViewModels -
    @StateObject private var wallViewModel: WallViewModel = WallViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let airedAt = message.airedAt {
                let date = airedAt.convertDateToString(dateFormat: "HH:mm dd/MM/yyyy")
                
                if let profileImage = wallViewModel.image {
                    Header(userName: wallViewModel.userName, profileImage: profileImage, date: date)
                } else {
                    Header(userName: wallViewModel.userName, profileImage: nil, date: date)
                }
            } else {
                if let profileImage = wallViewModel.image {
                    Header(userName: wallViewModel.userName, profileImage: profileImage, date: "")
                } else {
                    Header(userName: wallViewModel.userName, profileImage: nil, date: "")
                }
            }
            if message.type == .TEXT {
                Text(message.message)
                    .font(.subheadline)
            } else if message.type == .IMAGE {
                KFImage(URL(string: "http://127.0.0.1:8080\(message.message)"))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .cacheOriginalImage()
                .scaledToFit()
            }
        }
        .onAppear {
            wallViewModel.fetchUserMessageInfo(userId: message.user.id)
        }
    }
}

struct Header: View {
    // MARK: - Properties -
    var userName: String
    var profileImage: String?
    var date: String
    
    // MARK: - Main -
    var body: some View {
        HStack {
            if let image = profileImage {
                KFImage(URL(string: "http://127.0.0.1:8080\(image)"))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .cornerRadius(6)
                    }
                    .cacheOriginalImage()
                    .frame(width: 44, height: 44)
                    .cornerRadius(6)
                    .scaledToFit()
            } else {
                Rectangle()
                    .frame(width: 44, height: 44)
                    .cornerRadius(6)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.callout)
                    .bold()
                Text("\(date)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        let message: Message = .init(type: .TEXT, message: "Mensaje de Pepe", user: User.Id(id: "123456"))
        MessageRow(message: message)
            .previewLayout(.fixed(width: 200, height: 300))
    }
}
