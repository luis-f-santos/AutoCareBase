//
//  AuthViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/12/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign In.. inside AuthviewModel")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to SignIn with error \(error.localizedDescription)")
        }
        
        
    }
    
    func createUser(withEmail email: String, password: String, fullName: String,
                    phoneNumber: String, address: String) async throws {
        print("Creating user.. inside AuthviewModel")
        
        do {
            print(password)
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            //NEED TO: clean optional data to avoid nulls
            let user = User(id: result.user.uid, fullName: fullName, email: email,
                            address: address, phoneNumber: phoneNumber, password: password)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            // Update this Enviornmental Object
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            
        }
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to SignOut with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUG: CURRENT USER IS \(String(describing: self.currentUser))")
    }
}
