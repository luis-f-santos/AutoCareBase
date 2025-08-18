//
//  MessageService.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/17/25.
//

import Firebase

struct MessageService {
    
    private static let messagesCollection = Firestore.firestore().collection("messages")
    
    //TODO: need to make this an escaping function to return and array of Messages
    static func fetchMessages(withUserUid fromId: String, chatterUid toId: String) async throws -> [Message] {
        var messages = [Message]()
        let snapshots = try await messagesCollection.document(fromId).collection(toId).getDocuments()
        return messages
    }
    
    static func sendMessage(fromId: String, toId: String, message: String) async -> Bool{
        
        let senderDocument = messagesCollection
            .document(fromId)
            .collection(toId)
            .document()
        let recieverDocument = messagesCollection
            .document(toId)
            .collection(fromId)
            .document()
        let messageData = ["fromId": fromId, "toId": toId, "message": message,
                           "timestamp": Timestamp()] as [String: Any]
        do {
            try await senderDocument.setData(messageData)
            print("Sender message sent successfully")
            try await recieverDocument.setData(messageData)
            print("Reciever message sent successfully")
            return true
        } catch {
            print("Error sending message: \(error)")
            return false
        }
    }

}
