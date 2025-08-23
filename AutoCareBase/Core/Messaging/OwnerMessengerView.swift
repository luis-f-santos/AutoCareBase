//
//  OwnerMessengerView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/7/25.
//

import SwiftUI

struct OwnerMessengerView: View {
    
    let user: User
    @StateObject var viewModel: OwnerMessengerViewModel

    init(user: User){
        self.user = user
        self._viewModel = StateObject(wrappedValue: OwnerMessengerViewModel(uid: user.id))
    }

    @State var selectedRecentMessage : RecentMessage? = nil
    @State var selectedChatUserId : String? = nil
    @State var shouldShowNewMessageScreen = false
    @State var shouldShowChatMessagesView = false

    
    var body: some View {
        HStack {
            Image("AustinWeirdAutosLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 55, height: 55)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 2)
                }
            VStack(alignment: .leading, spacing: 4) {
                Text("Austin Weird Autos")
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
                ForEach(viewModel.recentMessages) { rm in
                    NavigationLink(value: rm.chattingToId) {
                        Button{
                            selectedChatUserId = rm.chattingToId
                            selectedRecentMessage = rm
                            shouldShowChatMessagesView.toggle()
                        } label: {
                            OwnerMessengerCellView(recentMessage: rm)
                        }
                        .foregroundColor(.black)
                        Divider()
                    }
                }
            }
            .padding(.top, 8)
//                .searchable(text: $searchText, prompt: "Search...")
        }
        .navigationDestination(isPresented: $shouldShowChatMessagesView, destination: {
//            if let selectedRecentMessage = self.selectedRecentMessage {
                ChatLogView(currentUser: self.user,selectedUserId: selectedChatUserId)
//            }
            
        })
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
