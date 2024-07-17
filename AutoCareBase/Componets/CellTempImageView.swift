//
//  CellTempImageView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/22/24.
//

import SwiftUI
import Kingfisher

struct CellTempImageView: View {
    let post: Post
    
    var body: some View {
        if let index = post.imageURLsArray?.count {
            if let imageUrl = post.imageURLsArray?[0] {
                KFImage(URL(string: imageUrl))
                    .placeholder{ProgressView()}
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "car")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(.systemGray4))
                
            }
        }
    }
}

//struct CellTempImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellTempImageView(post: Post.MOCK_POSTS[0])
//    }
//}
