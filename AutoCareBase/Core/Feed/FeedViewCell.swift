//
//  FeedViewCell.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/17/24.
//

import SwiftUI
import Kingfisher

struct FeedViewCell: View {
    let post: Post
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Image(post.make)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height:40)
//                    .clipped()
                Text(post.year + " "
                     + post.make + " "
                        + post.model)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.leading, 8)
            
            // Feed Image
            VStack {
                TabView{
                    ForEach(0..<post.imageURLsArray!.count, id: \.self) { i in
                        KFImage(URL(string: post.imageURLsArray![i]))
                            .placeholder{ProgressView().tint(.white)}
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
//                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode:
            }
            .frame(width: UIScreen.main.bounds.width, height: 400)
            .background(.black)
            
            // Likes
            HStack {
                Button {
                    print("Like button pushed")
                } label: {
                    Image(systemName: "heart")
                        .imageScale(.large)
                }
                
                Spacer()
                
                Text(String(post.likes)).bold() +
                Text(" Likes")
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
            .padding(.top, 4)
            .foregroundColor(.black)
            
            //Description
            Text(post.description ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)
                .lineLimit(3)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 1)
            
            //Timestamp
            Text("6h ago")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
                .padding(.leading, 10)
                .padding(.top, 1)
                .foregroundColor(.gray)
        }
    }
}

struct FeedViewCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedViewCell(post: Post.MOCK_POSTS[1])
    }
}


