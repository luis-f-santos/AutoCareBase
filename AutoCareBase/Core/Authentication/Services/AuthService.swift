//
//  AuthService.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/16/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init() {
        
        Task{ try await loadUserData()}
    }
    
    @MainActor
    func logIn(withEmail email: String, password: String) async throws {
        print("Sign In.. inside AuthviewModel")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to SignIn with error \(error.localizedDescription)")
        }
        
        
    }
    
    @MainActor
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
            self.currentUser = user
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            // Update this Enviornmental Object
            //try await loadUserData()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let uid = self.userSession?.uid else { return }
        self.currentUser =  try await UserService.fetchUser(withUid: uid)
        print("DEBUG: CURRENT USER IS \(String(describing: self.currentUser))")
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
    
    
}
