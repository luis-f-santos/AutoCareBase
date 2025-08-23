//
//  MessageService.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/17/25.
//

import Firebase

struct MessageService {
    
    private static let messagesCollection = Firestore.firestore().collection("messages")
    private static let recentMessagesCollection = Firestore.firestore().collection("recent_messages")

    
    //TODO: need to make this an escaping function to return and array of Messages
    static func fetchMessages(withUserUid fromId: String, chatterUid toId: String) async throws -> [Message] {
        var messages = [Message]()
        let snapshots = try await messagesCollection.document(fromId).collection(toId).getDocuments()
        return messages
    }
    
    static func sendRecentMessage(fromCurrentUser: User, chattingToUser: User, message: String) async -> Bool{
        
        let senderMessageDocument = recentMessagesCollection
            .document(fromCurrentUser.id)
            .collection("messages")
            .document(chattingToUser.id)
        
        let recieverMessageDocument = recentMessagesCollection
            .document(chattingToUser.id)
            .collection("messages")
            .document(fromCurrentUser.id)
        
        let senderData = ["chattingToId": chattingToUser.id, "userName": chattingToUser.fullName,
                          "userInitials": chattingToUser.initials, "message": message,"timestamp": Timestamp()] as [String: Any]
        let recieverData = ["chattingToId": fromCurrentUser.id, "userName": fromCurrentUser.fullName,
                            "userInitials": fromCurrentUser.initials, "message": message,"timestamp": Timestamp()] as [String: Any]
        
        

        do {
            try await senderMessageDocument.setData(senderData)
            print("Sender recent_message saved successfully")
            try await recieverMessageDocument.setData(recieverData)
            print("Reciever recent_message saved successfully")
            return true
        } catch {
            print("Error sending recent message: \(error)")
            return false
        }
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
