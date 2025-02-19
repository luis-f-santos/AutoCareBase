//
//  LoginView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/10/24.

import SwiftUI

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
//    @EnvironmentObject var viewModel: AuthViewModel;
    @FocusState private var focusField: Field?
    
    var body: some View {
        
        NavigationStack{
            VStack{
                //Logo
                Image("AustinWeirdAutosLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .padding(.vertical, 20)
                
                // Sign In Form
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeHolder: "name@example.com")
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    
                    InputView(text: $password,
                              title: "Password",
                              placeHolder: "Enter your password",
                              isSecureField: true)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled()
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
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
                    .padding(.bottom, 5)
                }
            }
        }
        .padding()
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
