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
    
    func handleSend() {
        
        currentChatText = ""
    }
    
    @MainActor
    func fetchChattingToUser() async throws {
        guard let chatUserID = chattingToUserId else { return }
        self.chattingToUser = try await UserService.fetchUser(withUid: chatUserID)
    }
}

