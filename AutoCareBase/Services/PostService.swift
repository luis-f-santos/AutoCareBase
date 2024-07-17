//
//  PostService.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/18/24.
//

import Firebase

struct PostService {
    
    private static let postsCollection = Firestore.firestore().collection("posts")
    
    static func fetchPublicPosts() async throws -> [Post] {
        var posts = [Post]()
        let snapshots = try await postsCollection.whereField("isPublic", isEqualTo: true).getDocuments()
        for snap in snapshots.documents {
            let postDict = snap.data()
            let post = Post(postData: postDict)
            posts.append(post)
        }
        return posts
    }
    
    static func fetchUserPosts(withUid uid: String) async throws -> [Post] {
        var posts = [Post]()
        let snapshots = try await postsCollection.whereField("userId", isEqualTo: uid).getDocuments()
        for snap in snapshots.documents {
            let postDict = snap.data()
            let post = Post(postData: postDict)
            posts.append(post)
        }
        return posts
    }
    
    static func updatePostWith(postID: String, withKey: String, andValue: Any?)  async -> Bool{
        let postRef = Firestore.firestore().collection("posts").document(postID)
        let data: [String: Any] = [
            withKey: andValue as Any
        ]
        do {
            try await postRef.updateData(data)
            print("Document successfully updated")
            return true
        } catch {
            print("Error updating document: \(error)")
            return false
        }
    }
    
    static func updatePostIamgesWith(postID: String, withKey: String, url: String)  async -> Bool{
        let postRef = Firestore.firestore().collection("posts").document(postID)
        let data: [String: Any] = [
            "imageURLs."+withKey: url
        ]
        //{'inPack.$packId': false}
        do {
            try await postRef.updateData(data)
            print("Document successfully updated")
            return true
        } catch {
            print("Error updating document: \(error)")
            return false
        }
        
    }
}
