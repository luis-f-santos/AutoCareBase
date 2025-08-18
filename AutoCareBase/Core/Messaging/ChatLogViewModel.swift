//
//  ChatLogViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import SwiftUI
import Firebase

@MainActor
class ChatLogViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var currentChatText = ""
    @Published var chattingToUser: User?
    @Published var shouldScrollToBottom = false
    @Published var initialStartToBottom = false
    
    let currentUser: User
    let chattingToUserId: String?

    init(currentUser: User, chatterId: String?) {
        self.currentUser = currentUser
        self.chattingToUserId = chatterId
        guard let chattingToId = self.chattingToUserId else { return }
        Task {
            await fetchMessages(withUserUid: currentUser.id, chatterUid: chattingToId)
            initialStartToBottom.toggle()
        }
        Task {
            try await fetchChattingToUser()
        }
        
    }
    
    private func fetchMessages(withUserUid fromId: String, chatterUid toId: String) async {

        Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    print("Failed to fetch Messages")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.messages.append(
                            .init(documentId:change.document.documentID, data: data ))
                    }
                })
                
                DispatchQueue.main.async {
                    self.shouldScrollToBottom.toggle()
                }
            }
                
    }
    
    func didSucccefullySendChat() async -> Bool {
        
        guard let toId = chattingToUserId else { return false }
        
        if(await MessageService.sendMessage(fromId: currentUser.id, toId: toId, message: currentChatText)){
            currentChatText = ""
            shouldScrollToBottom.toggle()
            return true
        } else {
            return false
        }
    }
    
    @MainActor
    func fetchChattingToUser() async throws {
        guard let chatUserID = chattingToUserId else { return }
        self.chattingToUser = try await UserService.fetchUser(withUid: chatUserID)
    }
}

