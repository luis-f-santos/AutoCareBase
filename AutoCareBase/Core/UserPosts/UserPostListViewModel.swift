//
//  UserPostListViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/22/24.
//

import Foundation

@MainActor
class UserPostListViewModel: ObservableObject {
    @Published var didComebackFromUpdating = false

    @Published var posts = [Post]()
    @Published var titleName: String?
    
    let userId: String
    
    init(uid: String) {
        self.userId = uid
        self.titleName = uid
        Task { try await fetchAllPosts(withUserId: uid)
            didComebackFromUpdating = true
        }
    }

    @MainActor
    func fetchAllPosts(withUserId uid: String) async throws {
        self.posts = try await PostService.fetchUserPosts(withUid: uid)
    }
    
    func getData() async throws {
        
        didComebackFromUpdating = false
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        didComebackFromUpdating = true
    }
    
    @MainActor
    func reloadPosts() async throws {
        didComebackFromUpdating = false
        self.posts = try await PostService.fetchUserPosts(withUid: self.userId)
        didComebackFromUpdating = true
    }
}
                                       
