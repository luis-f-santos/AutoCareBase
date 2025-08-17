//
//  ChatLogViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import SwiftUI

@MainActor
class ChatLogViewModel: ObservableObject {
    @Published var messages = [String]()
    @Published var currentChatText = ""
    @Published var chattingToUser: User?

//    @Published var didComebackFromUpdating = false
    
    let currentUser: User
    let chattingToUserId: String?

    init(currentUser: User, chatterId: String?) {
        self.currentUser = currentUser
        self.chattingToUserId = chatterId
        guard chatterId != nil else { return }
        Task {
            try await fetchChattingToUser()
        }
    }
    
    func didSucccefullySendChat() async -> Bool {
        
        guard let toId = chattingToUserId else { return false }
        
        if(await MessageService.sendMessage(fromId: currentUser.id, toId: toId, message: currentChatText)){
            currentChatText = ""
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

