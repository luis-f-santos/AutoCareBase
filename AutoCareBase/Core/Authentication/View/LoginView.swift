//
//  LoginView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/10/24.

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
//    @EnvironmentObject var viewModel: AuthViewModel;
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                //Logo
                Image("AustinWeirdAutosLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .padding(.vertical, 30)
                
                // Email Address Form
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeHolder: "name@example.com")
                    .textInputAutocapitalization(.never)
                    InputView(text: $password,
                              title: "Password",
                              placeHolder: "Enter your password",
                              isSecureField: true)
                    .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    Task {
                        try await AuthService.shared.logIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("LOG IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                NavigationLink {
                    RegistrationView().navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
