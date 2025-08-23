//
//  RecentMessage.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/20/25.
//

import Foundation

struct RecentMessage: Identifiable {
    
    var id: String { documentId }
    let documentId: String
    let chattingToId: String
    let userName: String
    let userInitials: String
    let message: String
    let timestamp: String
    
    init (documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.chattingToId = data["chattingToId"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.userInitials = data["userInitials"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.timestamp = data["timestamp"] as? String ?? ""
    }
}
