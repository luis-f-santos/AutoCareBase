//
//  ChatLogView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import SwiftUI

struct ChatLogView: View {
    
    @StateObject var viewModel: ChatLogViewModel
    @State var errorSendingMessage = false
    
    init(currentUser: User, selectedUserId: String?){
        self._viewModel = StateObject(
            wrappedValue: ChatLogViewModel(currentUser: currentUser, chatterId: selectedUserId))
    }
        
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    ForEach(viewModel.messages) { (messageobj) in
                        if(viewModel.currentUser.id == messageobj.fromId ){
                            HStack {
                                Spacer()
                                HStack {
                                    Text(messageobj.message)
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                        } else {
                            HStack {
                                HStack {
                                    Text(messageobj.message)
                                        .foregroundStyle(.black)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    HStack {
                        Spacer()
                    }
                    .id("Empty")
                    .onReceive(viewModel.$shouldScrollToBottom) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                        }
                    }
                    .onReceive(viewModel.$initialStartToBottom) { _ in
                        withAnimation(.easeInOut(duration: 0.1).speed(5.0)) {
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
//            .padding(.top, drawPadding ? 1 : 0) .easeInOut(duration: 1.0).speed(2.0)
            
            HStack {
                ZStack(alignment: .leading) {
                    Text("Message...")
                        .opacity(viewModel.currentChatText.isEmpty ? 0.5 : 0)
                        .padding(.leading, 4)
                    TextEditor(text: $viewModel.currentChatText)
                        .opacity(viewModel.currentChatText.isEmpty ? 0.5 : 1)
                }
                .frame(height: 40)
                
                Button {
                    Task {
                        //TODO: before action need to diable sendButton
                        await viewModel.didSucccefullySendChat()
                        //TODO: After action enable button
                    }
                } label: {
                    Text("Send")
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(4)
            }
            .padding()
        }
        .navigationTitle(viewModel.chattingToUser?.shortName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor) //Removes back button text
    }
}
