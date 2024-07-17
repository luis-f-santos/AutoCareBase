//
//  UserPostCellViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 7/9/24.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase

@MainActor
class UserPostCellViewModel: ObservableObject {
        
    private var uiImage: UIImage?
    var saveSuccessful: Bool = false
    @Published var postImage: Image?
    @Published var cellDescription: String
    @Published var isPublic: Bool
    @Published var isComplete: Bool
    @Published var didOwnerAddImage: Bool = false
    @Published var isEditingEnabled: Bool = false
    @Published var isUpdating: Bool = false
    @Published var pickerItem: PhotosPickerItem? {
        didSet { Task {await loadImage(fromItem: pickerItem )}}
    }
    
    init(post: Post) {
        self.cellDescription = post.description
        self.isPublic = post.isPublic
        self.isComplete = post.isComplete
        
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
        self.didOwnerAddImage = true
    }
    
    func isThereChangesToSave(fromPost post: Post) -> Bool {
        if (post.isPublic != isPublic
            || post.isComplete != isComplete
                || self.didOwnerAddImage
                    || (cellDescription.caseInsensitiveCompare(post.description)
                        != .orderedSame)){
            return true
        }
        return false
    }
    
    func updateUserPostChanges(fromPost post: Post) async{
        if(post.isPublic != self.isPublic){
            saveSuccessful = await PostService.updatePostWith(postID: post.id,
                                                              withKey: "isPublic",
                                                              andValue: self.isPublic)
        }
        if(post.isComplete != self.isComplete){
            saveSuccessful = await PostService.updatePostWith(postID: post.id,
                                                              withKey: "isComplete",
                                                              andValue: self.isComplete)
        }
        if((cellDescription.caseInsensitiveCompare(post.description) != .orderedSame)){
            saveSuccessful = await PostService.updatePostWith(postID: post.id,
                                                              withKey: "description",
                                                              andValue: self.cellDescription)
        }
        if(self.didOwnerAddImage){
            guard let myImage = uiImage else {
                return
            }
            let imageUid = NSUUID().uuidString
            guard let imageUrl = await ImageUploader.uploadImage(image: myImage,
                                                                 fileName: imageUid) else {
                return
            }
            let imageKeyValue = ImageUploader.getImageMapKeyValue(fromUid: imageUid)
            saveSuccessful = await PostService.updatePostIamgesWith(postID: post.id,
                                                                    withKey: imageKeyValue,
                                                                    url: imageUrl)
        }
        if(saveSuccessful){
            self.isEditingEnabled = false
            self.didOwnerAddImage = false
        }
    }
    
    
    
}
