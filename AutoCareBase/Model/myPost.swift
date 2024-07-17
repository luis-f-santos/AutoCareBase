//
//  myPost.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/23/24.
//

import Foundation
import Firebase

struct myPost: Identifiable {
    let id: String
    var userId: String
    let year: String
    let make: String
    let model: String
    var description: String!
    var isComplete: Bool
    var isPublic: Bool
    var likes: Int
    var imageURLsArray: [String]?
    var imageURLDict:  Dictionary<String, Any>?
    let dateCreated: String
    var dateModified: String
//    let postRef: FIRDatabaseReference
    
    
    init(postData: Dictionary<String, Any>) {

        imageURLsArray = [String]()

        if let mapValue = postData["dateCreated"] as? String{
            dateCreated = mapValue
        }else{
            dateCreated = ""
        }
        if let mapValue = postData["dateModified"] as? String{
            dateModified = mapValue
        }
        else{
            dateModified = ""
        }
        if let mapValue = postData["description"] as? String{
            description = mapValue
        }else{
            description = ""
        }
        if let mapValue = postData["id"] as? String{
            id = mapValue
        }else{
            id = ""
        }
        if let mapValue = postData["userId"] as? String{
            userId = mapValue
        }else{
            userId = ""
        }
        if let mapValue = postData["isComplete"] as? Bool{
            isComplete = mapValue
        }else{
            isComplete = false
        }
        if let mapValue = postData["isPublic"] as? Bool{
            isPublic = mapValue
        }else{
            isPublic = false
        }
        if let mapValue = postData["likes"] as? Int{
            likes = mapValue
        }else{
            likes = 0
        }
        if let mapValue = postData["make"] as? String{
            make = mapValue
        }else{
            make = ""
        }
        if let mapValue = postData["model"] as? String{
            model = mapValue
        }else{
            model = ""
        }
        if let mapValue = postData["year"] as? String{
            year = mapValue
        }else{
            year = ""
        }
        
        //    _postRef = DataService.ds.REF_POSTS.child(_postID)

        if let mapValue = postData["imageURLs"] as? Dictionary<String, Any> {
            imageURLDict = mapValue
            
            for (k,v) in (Array(mapValue).sorted {$0.key < $1.key}) {
                imageURLsArray?.append(v as! String)
                print("sorted keys: \(k)")
            }
        }
    }
    
}
