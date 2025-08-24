//
//  UserService.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/18/24.
//

import Foundation
import Firebase

struct UserService {
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchAllUser() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        
    }
    
    static func fetchUserList(withoutUid uid: String) async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").whereField("id", isNotEqualTo: uid).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
}
