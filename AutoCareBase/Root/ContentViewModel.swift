//
//  ContentViewModel.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/16/24.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject {
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var appSettings: Settings?
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
        
        service.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
        
        service.$appSettings.sink { [weak self] appSettings in
            self?.appSettings = appSettings
        }
        .store(in: &cancellables)
        
        
    }
}
