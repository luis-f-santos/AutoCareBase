//
//  CreatePostViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/20/24.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase

@MainActor
class CreatePostViewModel: ObservableObject {
    
    @Published var postImage: Image?
    @Published var selectedMaker = AUTO_MAKERS_ARRAY[0] //Default selected
    @Published var selectedYear = ""
    @Published var selectedModel: String? = nil
    @Published var models: [String] = []
    private var uiImage: UIImage?
    
    @Published var pickerItem: PhotosPickerItem? {
        didSet { Task {await loadImage(fromItem: pickerItem )}}
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadDataOnCreate(userId: String) async throws -> (Bool){
        guard let myImage = uiImage else { return false }
        let imageUid = NSUUID().uuidString
        guard let imageUrl = await ImageUploader.uploadImage(image: myImage, fileName: imageUid) else { return false }
        return try await self.preparePostData(userId: userId, imageUrl: imageUrl, imageUid: imageUid)
    }
    
    func preparePostData(userId: String, imageUrl: String, imageUid: String) async throws -> (Bool) {
        //TODO: clean this String and push to constant DataServiceClass
        let postRef = Firestore.firestore().collection("posts").document()
        let currentDate = Date()
        let imageDateFormatter = DateFormatter()
        let postDateFormatter = DateFormatter()
        
        imageDateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        postDateFormatter.dateFormat = "MMMM d, yyyy"
        
        let imageMapKeyValue = imageDateFormatter.string(from: currentDate) + imageUid
        let postCreatedDate = postDateFormatter.string(from: currentDate)
        
        let postData: [String: Any] = [
            "id": postRef.documentID,
            "userId": userId,
            "year": selectedYear,
            "make": selectedMaker,
            "model": selectedModel,
            "description": "Need to add description",
            "likes": 0,
            "dateCreated": postCreatedDate,
            "dateModified": imageDateFormatter.string(from: currentDate),
            "imageURLs": [
                imageMapKeyValue : imageUrl
            ],
            "isComplete": false,
            "isPublic": false,
        ]

        do {
            try await postRef.setData(postData)
            print("Document successfully written!")
            return true
        
        } catch {
            print("Error writing document: \(error)")
            return false
        }
 
    }
}
