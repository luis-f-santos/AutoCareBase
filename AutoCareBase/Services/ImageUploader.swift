//
//  ImageUploader.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/22/24.
//

import UIKit
import Firebase
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, fileName: String) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return nil }
        let ref = Storage.storage().reference(withPath: "/post_images/\(fileName)")
        //withPath: "/profile_images/\(filename)"
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            print(url.absoluteString)
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    static func getImageMapKeyValue(fromUid: String) -> String{
        let currentDate = Date()
        let imageDateFormatter = DateFormatter()
        let postDateFormatter = DateFormatter()
        
        imageDateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        postDateFormatter.dateFormat = "MMMM d, yyyy"
        
        return imageDateFormatter.string(from: currentDate) + fromUid
        
    }
    
}
