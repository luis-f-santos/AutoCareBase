//
//  ProfileView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/13/24.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    @StateObject var viewModel: ProfileUserPostViewModel
    @State private var selectedPost: Post? = nil
    @State private var userUpdatedPost = false
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: ProfileUserPostViewModel(uid: user.id))
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                Section(viewModel.didComebackFromUpdating ? "Vehicles" : "Updating..."){
                    ForEach(viewModel.posts){ post in
                        Button{
                            selectedPost = post
                        } label: {
                            ProfileUserPostCell(post: post)
                        }
                        .foregroundColor(.black)
                    }
                }
                Section("Account"){
                    Button {
                        print("Sign Out Button clicked")
                        AppServices.shared.signOut()
                    } label: {
                        ProfileRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                }
            }
            .sheet(item: $selectedPost, onDismiss: {
                if(userUpdatedPost){
                    Task {
                        try await viewModel.reloadPosts()
                        userUpdatedPost.toggle()
                    }
                }
            }, content: { post in
                PostDetailView(post: post, didUpdatePublic: $userUpdatedPost)
                    .presentationDetents([.fraction(0.85)])
            })
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing ){
                    //TODO: Guard editable and Selected and reset on return
                    NavigationLink{
//                        var uid = AuthService.shared.currentUser?.id
//                        CreatePostView(userId: user.id, addedPostSuccess: $addedPostSuccess)
//                            .onDisappear(){
//                                if(addedPostSuccess){
//                                    Task{ try await viewModel.reloadPosts() }
//                                }
//                            }
                    } label: {
                        Image(systemName: "plus").foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        let myUser: User = User(id: "2dzu41yqMgS6ijnbaHGrQYa4EGe2", fullName: "Steph Curry", email: "myemail", address: "123 Oakland", phoneNumber: "12345", password: "qqqqq")
        ProfileView(user: myUser)
    }
}
