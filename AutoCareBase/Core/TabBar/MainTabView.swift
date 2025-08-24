//
//  MainTabView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/15/24.
//

import SwiftUI

struct MainTabView: View {
    let user: User
    
    var body: some View {
        TabView {
            if(AuthService.shared.ownerIsLoggedIn()){
                UsersListView()
                    .tabItem {
                        Image(systemName: "person")
                    }
            } else{
                ProfileView(user: user)
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                }
            LocationDetail()
                .tabItem {
                    Image(systemName: "location")
                }
        }
        .accentColor(.red)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let myUser: User = User(id: "abcd", fullName: "Steph Curry", email: "myemail", address: "123 Oakland", phoneNumber: "12345", password: "qqqqq")
        
        MainTabView(user: myUser)
    }
}
