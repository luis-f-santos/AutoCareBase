//
//  OwnerMessengerView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/7/25.
//

import SwiftUI

struct OwnerMessengerView: View {
    
    let user: User
    
    init(user: User){
        self.user = user
    }
    var viewsArray: [OwnerMessengerCellView] = [
        OwnerMessengerCellView(name: "View 1"),
        OwnerMessengerCellView(name: "View 2")
        ]
    
    var namesArray: [String] = ["Name1", "Name2"]
    
    @State var selectedChatUserId : String? = nil
    @State var shouldShowNewMessageScreen = false
    @State var shouldShowChatMessagesView = false

    
    var body: some View {
        HStack {
            Text(user.initials)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(Color(.systemGray3))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 4)
                HStack {
                    Text("")
                        .frame(width: 12, height: 12)
                        .background(Color(.green))
                        .clipShape(Circle())
                    Text("online")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.leading, 14)
        
        ScrollView {
            LazyVStack(spacing: 12){
                ForEach(namesArray, id: \.self) { viewName in
                    NavigationLink(value: viewName) {
                        Button{
//                            selectedChatUserId = viewName
//                            shouldShowChatMessagesView.toggle()
                        } label: {
                            OwnerMessengerCellView(name: viewName)
                        }
                        .foregroundColor(.black)
                    }
                    Divider()
                }
            }
            .padding(.top, 8)
//                .searchable(text: $searchText, prompt: "Search...")
        }
        .navigationDestination(isPresented: $shouldShowChatMessagesView,
                                    destination: {ChatLogView(currentUser: self.user,
                                                              selectedUserId: selectedChatUserId)})
        .navigationTitle("Messaging")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement:.navigationBarTrailing ){
                Button {
                    shouldShowNewMessageScreen.toggle()
                } label: {
                    Image(systemName: "envelope.badge.fill")
                }
            }
        }
        .sheet(isPresented: $shouldShowNewMessageScreen, onDismiss: {
            if selectedChatUserId != nil {
                shouldShowChatMessagesView.toggle()
            }
            
        }, content: {
            CreateNewMessageView(selectedChatUserId: $selectedChatUserId)
        })
    }
}

#Preview {
//    OwnerMessengerView()
}
