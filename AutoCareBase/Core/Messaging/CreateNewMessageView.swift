//
//  CreateNewMessageView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import SwiftUI

struct CreateNewMessageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = CreateNewMessageViewModel()
    @Binding var selectedChatUserId: String?
    @State var searchText = ""
    @State  var searchIsFocused = false
    
    var body: some View {
        NavigationView{
            ScrollView {
                if !searchIsFocused {
                    Text("Suggested")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity.combined(with: .scale(scale: 0.3, anchor: .top)))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                }
                ForEach(viewModel.myFilteredArray){ user in
                    Button {
                        selectedChatUserId = user.id
                        var shortname = user.shortName
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            Text(user.initials)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 55, height: 55)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            Text(user.fullName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.label))
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle()) // Helps button tap more passive
                    Divider()
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        selectedChatUserId = nil
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .transition(.move(edge: .leading))
//            .searchable(text: $searchText, isPresented: $searchIsFocused, prompt:"Search for User")
                
        }
        .transition(.move(edge: .leading))
    }
}
