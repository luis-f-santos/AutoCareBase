//
//  FeedView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/17/24.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedViewCell(post: post)
                    }
                }
            }
            .refreshable {
                Task { try await viewModel.fetchAllPublicPost() }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing ){
                    if let currentUser = AuthService.shared.currentUser {
                        NavigationLink{
                            OwnerMessengerView(user: currentUser)
                        } label: {
                            Image(systemName: "message").foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
        
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
