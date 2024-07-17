//
//  RegistrationView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/12/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack{
            ScrollView {
                //Logo
                Image("AustinWeirdAutosLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .padding(.vertical, 30)
                
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeHolder: "name@example.com")
                    .textInputAutocapitalization(.never)
                    InputView(text: $fullName,
                              title: "Full Name",
                              placeHolder: "Enter your name")
                    InputView(text: $phoneNumber,
                              title: "Phone Number",
                              placeHolder: "512-XXX-XXXX")
                    InputView(text: $address,
                              title: "Address - Optional",
                              placeHolder: "123 Main St")
                    InputView(text: $password,
                              title: "Password",
                              placeHolder: "Enter your password",
                              isSecureField: true)
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword,
                                  title: "Confirm Password",
                                  placeHolder: "Confirm your password",
                                  isSecureField: true)
                        if !password.isEmpty && !confirmPassword.isEmpty
                            && password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()

            Button {
                print("Sign Up button clicked")
                Task {
                    try await AuthService.shared.createUser(withEmail: email,
                                                   password: password,
                                                   fullName: fullName,
                                                   phoneNumber: phoneNumber,
                                                   address: address)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
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
            .padding(.top, 16)
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 8)
        }
    }
    
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !phoneNumber.isEmpty
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
