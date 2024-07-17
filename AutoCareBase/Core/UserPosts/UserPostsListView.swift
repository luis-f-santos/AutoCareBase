//
//  UserPostsListView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/19/24.
//

import SwiftUI

struct UserPostsListView: View {
    
    let user: User
    @StateObject var viewModel: UserPostListViewModel
    @State private var showProgessView = false
    @State private var addedPostSuccess = false
    @State private var selectedPostId: String? = nil
    
    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: UserPostListViewModel(uid: user.id))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 12){
                    ForEach(viewModel.posts){ post in
                        UserPostCellView(post:post, selectedPostId: $selectedPostId,
                                         isUpdating: $showProgessView)
                        Divider()
                    }
                    
                }
                .padding(.top, 8)
            }
            .navigationTitle(user.shortName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing ){
                    //TODO: Guard editable and Selected and reset on return
                    NavigationLink{
                        CreatePostView(userId: user.id, addedPostSuccess: $addedPostSuccess)
                            .onDisappear(){
                                if(addedPostSuccess){
                                    Task{ try await viewModel.reloadPosts() }
                                }
                            }
                    } label: {
                        Image(systemName: "plus").foregroundColor(.black)
                    }
                }
            }
            if(showProgessView){
                ZStack {
                    Color(.black)
                        .ignoresSafeArea()
                        .opacity(0.75)
                    ProgressView("Saving...")
                        .tint(.white)
                        .brightness(1)
                }
            }
        }
    }
    
    func passedFunction(myFirstParameter: String, mySecondParameter: Int) -> Bool{
        print("I am the parent")
        return false
        }
}

struct UserPostsListView_Previews: PreviewProvider {
    static var previews: some View {
        UserPostsListView(user: User.MOCK_USERS[0])
    }
}
