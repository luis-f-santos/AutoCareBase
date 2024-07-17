//
//  Post.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/18/24.
//
import Foundation
import Firebase

struct Post: Identifiable {
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
            
            for (k,v) in (Array(mapValue).sorted {$0.key > $1.key}) {
                imageURLsArray?.append(v as! String)
                print("sorted keys: \(k)")
            }
        }
    }
    
}



extension Post {
    
    static var MOCK_POSTS: [Post] = [.init(postData: ["id":NSUUID().uuidString,
                                                   "userId" : "2",
                                                   "year": "2015",
                                                   "make": "Toyota",
                                                   "model":"Corolla",
                                                   "description": "Just put in Creaing bigger long text to see if text elipseing or to see how many lines it takes for the description to cut off. Currently at 5 lines but trying to see if it ellipss the next line",
                                                   "isComplete": false,
                                                   "isPublic": false,
                                                   "llikes": 4,
                                                   "imageURLsArray":["https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/post_images%2FF714E446-1DB4-4BBE-AD94-FF69F8F969CE?alt=media&token=ddfad287-5196-405d-8252-9870faa73ac4", "https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/post_images%2FEC9A2B14-899B-4852-B3B5-1BF7D9EFFA1F?alt=media&token=8e1788ed-4942-4cb0-842a-2da691ec29ca"],
                                                      "imageURLDict":["1":"https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/post_images%2FF714E446-1DB4-4BBE-AD94-FF69F8F969CE?alt=media&token=ddfad287-5196-405d-8252-9870faa73ac4", "2":"https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/post_images%2FEC9A2B14-899B-4852-B3B5-1BF7D9EFFA1F?alt=media&token=8e1788ed-4942-4cb0-842a-2da691ec29ca"],
                                                   "dateCreated":"asdfad",
                                                   "dateModified":""
                                                  ]), .init(postData: [ "id":"1454264",
                                                                        "userId" : "2",
                                                                        "year": "2013",
                                                                        "make": "BMW",
                                                                        "model":"Rav4",
                                                                        "description": "Just put in",
                                                                        "isComplete": false,
                                                                        "isPublic": false,
                                                                        "llikes": 4,
                                                                        "imageURLsArray":"",
                                                                        "imageURLDict":"",
                                                                        "dateCreated":"asdfad",
                                                                        "dateModified":""
                                                                      ]), .init(postData: [ "id":NSUUID().uuidString,
                                                                                            "userId" : "2",
                                                                                            "year": "2008",
                                                                                            "make": "Toyota",
                                                                                            "model":"Highlander",
                                                                                            "description": "Just put in",
                                                                                            "isComplete": false,
                                                                                            "isPublic": false,
                                                                                            "llikes": 4,
                                                                                            "imageURLsArray":nil,
                                                                                            "imageURLDict":nil,
                                                                                            "dateCreated":"asdfad", ])]

    
//    var imageArray = ["https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/post_images%2FF714E446-1DB4-4BBE-AD94-FF69F8F969CE?alt=media&token=ddfad287-5196-405d-8252-9870faa73ac4", "https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/post_images%2FEC9A2B14-899B-4852-B3B5-1BF7D9EFFA1F?alt=media&token=8e1788ed-4942-4cb0-842a-2da691ec29ca"]
    
//    static var MOCK_POSTS: [Post] = [
//        .init(postData: <#[String : Any]#>, id: NSUUID().uuidString, userId: "1", year: "1989", make: "BMW", model: "e30", description: "Description of what work of current progress of project that might takeup two lines I want to try if it will go to four lines",isComplete: false, isPublic: true, likes: 12, dateCreated: DateFormatter().string(from: Date()), dateModified: DateFormatter().string(from: Date())),
//        .init(id: NSUUID().uuidString, userId: "2", year: "1997", make: "Toyota", model: "4Runner", description: "Description of what work", isComplete: false, isPublic: true, likes: 9, imageURLs: ["https://firebasestorage.googleapis.com:443/v0/b/autocarebase-76a27.appspot.com/o/temp_images%2F7BA8DE70-DD96-468E-B3A3-B11B78663373?alt=media&token=6196d92f-8f39-4a69-9b90-a3679969856b"], dateCreated: DateFormatter().string(from: Date()), dateModified: DateFormatter().string(from: Date())),
//        .init(id: NSUUID().uuidString, userId: "3", year: "2006", make: "Scion", model: "TC", description: "Description of what work of current progress of project that might takeup two lines", isComplete: false, isPublic: true, likes: 23, imageURLs: nil, dateCreated: DateFormatter().string(from: Date()), dateModified: DateFormatter().string(from: Date()))
//    ]
}


