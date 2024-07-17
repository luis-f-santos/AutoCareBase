//
//  PostDetailView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/27/24.
//

import SwiftUI
import Foundation
import Kingfisher

struct PostDetailView: View {
    var post: Post
    @Binding var didUpdatePublic: Bool
    @StateObject var viewModel = PostDetailPostViewModel()    
    
    var body: some View {
        VStack {
            Capsule()
                    .fill(Color.secondary)
                    .frame(width: 30, height: 3)
                    .padding(10)
            VStack {
                TabView{
                    ForEach(0..<post.imageURLsArray!.count, id: \.self) { i in
                        KFImage(URL(string: post.imageURLsArray![i]))
                            .placeholder{ProgressView().tint(.white)}
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .frame(width: UIScreen.main.bounds.width, height: 300)
            .background(.black)
            
            Text(post.description)
                .padding(.top, 36)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            if(!post.isPublic){
                Text(viewModel.shareDescription)
                    .padding(.top, 36)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
                    .font(.caption)
                Button {
                    Task {
                        self.didUpdatePublic = await viewModel.shareBtnTapped(postID: post.id)
                    }
                } label: {
                    HStack{
                        Text("Share")
                    }
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .padding(.horizontal)
                }
                .background(Color(.systemRed))
                .cornerRadius(6)
                .disabled(viewModel.disableShareButton)
            }
            Spacer()
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: Post.MOCK_POSTS[1], didUpdatePublic: .constant(false))
    }
}
