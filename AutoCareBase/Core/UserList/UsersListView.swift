//
//  OwnersUsersListView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/17/24.
//

import SwiftUI

struct UsersListView: View {
    @State private var searchText = ""
    @StateObject var viewModel = UsersListViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVStack(spacing: 12){
                    ForEach(viewModel.users){ user in
                        NavigationLink(value: user) {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 55, height: 55)
                                    .background(Color(.systemGray3))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(user.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .accentColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        }
                    }
                }
                .padding(.top, 8)
                .searchable(text: $searchText, prompt: "Search...")
                
                Section("Account"){
                    HStack() {
                        Button {
                            print("Sign Out Button clicked")
                            AuthService.shared.signOut()
                        } label: {
                            ProfileRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                                
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.leading, 24)
                }
            }
            .navigationDestination(for: User.self, destination: { user in
                UserPostsListView(user: user)
            })
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
