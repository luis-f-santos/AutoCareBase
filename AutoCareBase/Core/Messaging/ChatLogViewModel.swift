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
    @Published var errorFound = false
    @Published var shouldScrollToBottom = false
    @Published var initialStartToBottom = false
    
    let currentUser: User
    let chattingToUserId: String?

    init(currentUser: User, chatterId: String?) {
        self.currentUser = currentUser
        self.chattingToUserId = chatterId
        guard let chattingToId = self.chattingToUserId else { return }
        print("inside init")
        Task {
            await fetchMessages(withUserUid: currentUser.id, chatterUid: chattingToId)
            try await fetchChattingToUser()
            initialStartToBottom.toggle()
//            count += 1
        }
//        DispatchQueue.main.async {
//            print("toggled initialStartToBottom outside Task")
//            self.count += 1
//        }
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
                    print("updated count inside SnapshotListener")
                    self.shouldScrollToBottom.toggle()
                }
            }
    }
    
    func didSucccefullySendChat() async -> Bool {
        
        guard let chattingUser = chattingToUser else { return false }
        Task {
            let sentMSucces = await MessageService.sendMessage(fromId: currentUser.id, toId: chattingUser.id,
                                                               message: currentChatText)
            let sentRMSuccess = await MessageService.sendRecentMessage(fromCurrentUser: currentUser,
                                                      chattingToUser: chattingUser, message: currentChatText)
            if(sentMSucces && sentRMSuccess){
                currentChatText = ""
                shouldScrollToBottom.toggle()
                print("Both MessageService calls returned with success")
                return true
            } else {
                    print("Error occured while waiting to send message")
                return false
            }
        }
        return false
    }
    
    @MainActor
    func fetchChattingToUser() async throws {
        guard let chatUserID = chattingToUserId else { return }
        self.chattingToUser = try await UserService.fetchUser(withUid: chatUserID)
    }
}

