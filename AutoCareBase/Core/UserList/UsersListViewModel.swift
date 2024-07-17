//
//  OwnersUsersViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/18/24.
//

import Foundation

class UsersListViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchAllUsers() }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUser()
    }
}
