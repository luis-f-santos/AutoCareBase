//
//  ContentView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/10/24.
//

import SwiftUI

struct ContentView: View {
//    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
                
            } else if let currentUser = viewModel.currentUser,
                                let settings = viewModel.appSettings {
                MainTabView(user: currentUser)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
