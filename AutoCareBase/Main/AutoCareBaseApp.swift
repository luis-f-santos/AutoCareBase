//
//  AutoCareBaseApp.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/10/24.
//

import SwiftUI
import Firebase

@main
struct AutoCareBaseApp: App {
//    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()//.environmentObject(viewModel)
        }
    }
}
