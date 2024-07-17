//
//  ProfileUserPostViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/24/24.
//

import Foundation

@MainActor
class ProfileUserPostViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var didComebackFromUpdating = false
    let userId: String

    init(uid: String) {
        self.userId = uid
        Task { try await fetchAllPosts(withUserId: uid)
            didComebackFromUpdating = true
        }
    }

    @MainActor
    func fetchAllPosts(withUserId uid: String) async throws {
        self.posts = try await PostService.fetchUserPosts(withUid: uid)
    }
    
    @MainActor
    func reloadPosts() async throws {
        didComebackFromUpdating = false
        self.posts = try await PostService.fetchUserPosts(withUid: self.userId)
        didComebackFromUpdating = true
    }
}
