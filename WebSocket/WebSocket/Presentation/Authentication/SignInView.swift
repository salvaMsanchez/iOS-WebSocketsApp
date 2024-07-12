//
//  SignInView.swift
//  WebSocket
//
//  Created by Salva Moreno on 30/3/24.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack(spacing: 0) {
            GradientHeader()
                .aspectRatio(1.75, contentMode: .fit)
            
            SignInForm()
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct GradientHeader: View {
    // MARK: - Main
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gradientBottom, .gradientTop],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask {
                LinearGradient(
                    colors: [.black, .clear],
                    startPoint: .top,
                    endPoint: .bottom)
            }
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 40)
        }
    }
}

private struct SignInForm: View {
    // MARK: - Properties
    @EnvironmentObject private var sessionViewModel: SessionViewModel
    @EnvironmentObject private var routeViewModel: RouteViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var signInDone = false
    @State private var showSignUp = false
    @State private var userNotAuthenticated = false
    
    // MARK: - Main
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 5) {
                Text("sign_in")
                    .font(.largeTitle)
                
                Text("sign_in_acces_account")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
         
            VStack(spacing: 10) {
                HStack(spacing: 5) {
                    Image(.envelopeCircleFill)
                        .font(.system(size: 38))
                        .foregroundColor(Color(.systemGray2))
                        .padding(2)
                    
                    TextField("sign_in_email_placeholder", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(Color(.systemGray5))
                )
                
                HStack(spacing: 5) {
                    Image(.lockCircleFill)
                        .font(.system(size: 38))
                        .foregroundColor(Color(.systemGray2))
                        .padding(2)
                    
                    TextField("sign_in_password_placeholder", text: $password)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                }
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(Color(.systemGray5))
                )
            }
            
            VStack(spacing: 10) {
                Button {
                    sessionViewModel.signIn(email: email, password: password) { result in
                        switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    signInDone = true
                                }
                            case .failure(let error):
                                userNotAuthenticated = true
                                print(error)
                        }
                    }
                } label: {
                    Text("sign_in")
                        .font(.headline)
                        .foregroundColor(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.label))
                        .cornerRadius(.infinity)
                }
                .buttonStyle(LoadingButton(isLoading: $sessionViewModel.isLoading))
                
                Button {
                    showSignUp = true
                } label: {
                    let noAccount = Text("sign_in_no_account")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                    
                    let signUp = Text("sign_in_sign_up")
                        .font(.subheadline)
                        .bold()
                    
                    Text("\(noAccount) \(signUp)")
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: signInDone, perform: { newValue in
            if newValue {
                sessionViewModel.getUserId(email: email) { result in
                    switch result {
                        case .success(let userId):
                            UserDefaults.standard.setValue(userId.id, forKey: Constants.userId)
                            DispatchQueue.main.async {
                                routeViewModel.screen = .tabs
                            }
                        case .failure(let error):
                            print(error)
                    }
                }
            }
        })
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .alert("user_not_authenticated", isPresented: $userNotAuthenticated, actions: {
            Text("OK")
        }, message: {
            Text("user_not_authenticated_message")
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(RouteViewModel())
            .environmentObject(SessionViewModel())
    }
}
