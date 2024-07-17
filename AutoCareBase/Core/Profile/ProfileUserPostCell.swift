//
//  UserPostCell.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/18/24.
//

import SwiftUI
import Kingfisher

struct ProfileUserPostCell: View {
    let post: Post
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Image(post.make)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height:40)
                    .padding(.leading, 12)
                VStack(alignment: .leading){
                    Text(post.year)
                        .font(.title2)
                    Text(post.make + " " + post.model)
                        .font(.title2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 12, height:12)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                    .foregroundColor(Color.gray)
            }
            HStack(spacing: 0) {
                HStack{
                    CellTempImageView(post:post)
                }
                .frame(width: 150, height:120)
                .clipped()
                
                Text(post.description)
                    .font(.system(size: 14))
                    .padding(.leading, 10)
                    .lineLimit(5)
                Spacer()
            }
            .padding(.top, 8)
        }
    }
}

struct ProfileUserPostCell_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserPostCell(post: Post.MOCK_POSTS[0])
    }
}
