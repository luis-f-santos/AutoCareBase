//
//  CreatePostView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/20/24.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    
    let userId: String
    @Binding var addedPostSuccess: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var showProgessView = false
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel = CreatePostViewModel()
    
    var body: some View {
        ZStack {
            VStack(){
                Text("Select Maker")
                    .font(.title)
                
                Picker("My Picker", selection: $viewModel.selectedMaker) {
                    ForEach(AUTO_MAKERS_ARRAY, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.wheel)
                
                HStack(spacing: 10) {
                    TextField("Add Model Year", text: $viewModel.year)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Add Model Name", text: $viewModel.model)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Text("Add Image")
                    .padding(.top, 16)
                
                Button {
                    print("DEBUG: Add Image Button tapped")
                    isPhotoPickerPresented.toggle()
                } label: {
                    if let image = viewModel.postImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
    //                        .clipped()
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.top, 12)
                    }
                }

                Button {
                    Task {
                        //TODO: add guards to disable button
                        showProgessView = true
                        addedPostSuccess = try await viewModel.uploadDataOnCreate(userId: userId)
                        dismiss()
                    }
                } label: {
                    HStack {
                        Text("Create")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .foregroundColor(.white)
                .background(Color(.red))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
            }
            .photosPicker(isPresented: $isPhotoPickerPresented, selection: $viewModel.pickerItem)
            if(showProgessView){
                ZStack {
                    Color(.black)
                        .ignoresSafeArea()
                        .opacity(0.75)
                    ProgressView("Updating...")
                        .tint(.white)
                        .brightness(1)
                }
            }
        }
    }
}

extension CreatePostView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.year.isEmpty && viewModel.year.count == 4
            && Int(viewModel.year) != nil
                && !viewModel.model.isEmpty && viewModel.model.count > 1
                    && viewModel.postImage != nil
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(userId: User.MOCK_USERS[0].id, addedPostSuccess: .constant(false))
    }
}
