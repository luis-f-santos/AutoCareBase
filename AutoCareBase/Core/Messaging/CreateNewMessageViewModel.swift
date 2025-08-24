//
//  CreateNewMessageViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import Foundation

class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var searchText = ""
    
    var myFilteredArray: [User] {
        if searchText.isEmpty {
            users
        } else {
            users.filter { $0.fullName.localizedStandardContains(searchText)}
        }
    }
    
    init() {
        Task { try await fetchMessageUserList() }
    }
    
    @MainActor
    func fetchMessageUserList() async throws {
        if let currentUser = AuthService.shared.currentUser{
            self.users = try await UserService.fetchUserList(withoutUid: currentUser.id)
        }
        
    }
}
