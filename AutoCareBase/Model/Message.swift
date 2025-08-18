//
//  Message.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/18/25.
//

import Foundation

struct Message: Identifiable {
    
    var id: String { documentId }
    let documentId: String
    let fromId: String
    let toId: String
    let message: String
    let timestamp: String
    
    init (documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.timestamp = data["timestamp"] as? String ?? ""
    }
}
