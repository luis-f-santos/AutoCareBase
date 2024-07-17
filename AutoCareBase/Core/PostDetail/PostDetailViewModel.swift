//
//  PostDetailViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 7/1/24.
//

import Foundation
import Firebase

@MainActor
class PostDetailPostViewModel: ObservableObject {
    
    @Published var disableShareButton: Bool = false
    @Published var shareDescription = "Would you like to share your car's progess to our feed?"
    
    func shareBtnTapped(postID: String) async -> Bool{
        if(await PostService.updatePostWith(postID: postID, withKey: "isPublic", andValue: true)){
            disableShareButton = true
            shareDescription = "Thank You for sharing!"
            return true
        } else {
            return false
        }
    }
}
