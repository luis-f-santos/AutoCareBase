//
//  ChatLogView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import SwiftUI

struct ChatLogView: View {
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    init(currentUser: User, selectedUserId: String?){
        self._viewModel = ObservedObject(
            wrappedValue: ChatLogViewModel(currentUser: currentUser, chatterId: selectedUserId))
    }
        
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0..<20) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text(" Fake longer half Message")
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                HStack {
                    Spacer()
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
//            .defaultScrollAnchor(.bottom)
            
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
                    viewModel.handleSend()
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
        .navigationTitle(viewModel.chattingToUser?.id ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
  
}

