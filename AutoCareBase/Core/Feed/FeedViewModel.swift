//
//  FeedViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/23/24.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        Task { try await fetchAllPublicPost() }
    }
    
    @MainActor
    func fetchAllPublicPost() async throws {
        self.posts = try await PostService.fetchPublicPosts()
    }
}
