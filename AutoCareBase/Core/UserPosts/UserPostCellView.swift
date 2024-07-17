//
//  UserPostCellView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/19/24.
//

import SwiftUI
import PhotosUI
    
struct UserPostCellView: View {
    
    let post: Post
    @Binding var selectedPostId: String?
    @Binding var isPostUpdating: Bool
//    var myFunctionWithParameters: (String, Int) -> (Bool)
    @State private var alertText = "Are you sure you want save these changes?"
    @State private var alertDestrucText = "Save"
    @State private var isPhotoPickerPresented = false
    @State private var showSaveAlert = false
    @StateObject var viewModel: UserPostCellViewModel
        
    init(post: Post, selectedPostId: Binding<String?>, isUpdating: Binding<Bool>)/*, myFunctionWithParameters: @escaping (String, Int) -> Void*/  {
        self.post = post
        _selectedPostId = selectedPostId
        _isPostUpdating = isUpdating
//        self.myFunctionWithParameters = myFunctionWithParameters
        self._viewModel = StateObject(wrappedValue: UserPostCellViewModel(post: post))
    }
    
    var body: some View {
        HStack{
            VStack {
                Button {
                    //TODO:
                    isPhotoPickerPresented.toggle()
                } label: {
                    ZStack {
                        HStack{
    //                        CellTempImageView(post:post)
                            if let image = viewModel.postImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                CellTempImageView(post:post)
                            }
                        }
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0.3))
                            .opacity(viewModel.isEditingEnabled ? 1: 0)
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .opacity(viewModel.isEditingEnabled ? 1: 0)
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    .frame(width: UIScreen.main.bounds.width * (2/5), height: 110)
                    .clipped()
                    .background(Color.black)
                }
                .disabled(!viewModel.isEditingEnabled)
                
                Text("Add image one at a time")
                    .font(.system(size: 10))
                    .opacity(viewModel.isEditingEnabled ? 1: 0)
                
                Button {
                    //TODO:
                    viewModel.isPublic.toggle()
                } label: {
                    HStack{
                        Text(viewModel.isPublic ? "Public":"Not Public")
                    }
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .padding(.horizontal)
                }
                .background(Color(.systemCyan))
                .cornerRadius(6)
                .padding(.top, 10)
                .disabled(!viewModel.isEditingEnabled)
                
                Spacer()
            }
            
            VStack(){
                Text(post.year + " " + post.make + " " + post.model)
                    .fontWeight(.semibold)
                HStack {
                    Button {
                        if selectedPostId != nil { return }
                        selectedPostId = post.id
                        viewModel.isEditingEnabled.toggle()
//                        self.myFunctionWithParameters("", 1)
                    } label: {
                        HStack{
                            Text("Edit")
                        }
                        .foregroundColor(viewModel.isEditingEnabled ? .black : .white)
                        .frame(height: 30)
                        .padding(.horizontal)
                    }
                    .background(viewModel.isEditingEnabled ? Color.clear : Color.red)
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(.red, lineWidth: 1))
                    
                    Spacer()
                    
                    Button {
                        if(viewModel.isThereChangesToSave(fromPost: post)){
                            showSaveAlert.toggle()
                        }else{
                            selectedPostId = nil
                            viewModel.isEditingEnabled.toggle()
                        }
                    } label: {
                        HStack{
                            Text("Save")
                        }
                        .foregroundColor(.white)
                        .frame(height: 30)
                        .padding(.horizontal)
                    }
                    .background(Color(.systemGreen))
                    .cornerRadius(6)
                    .opacity(viewModel.isEditingEnabled ? 1: 0)
                    
                }
                TextField(post.description,
                          text: $viewModel.cellDescription, axis: .vertical)
                    .frame(height: 80, alignment: .top)
                    .padding(.leading, 4)
                    .overlay(RoundedRectangle(cornerRadius: 2)
                        .stroke(viewModel.isEditingEnabled ? Color.red: Color(.systemGray5)))
                    .background(Color(.white))
                    .foregroundColor(viewModel.isEditingEnabled ? Color(.darkGray) : .black)
                    .font(.system(size: 14))
                    .disabled(!viewModel.isEditingEnabled)

                
                HStack {
                    Button {
                        viewModel.isComplete.toggle()
                    } label: {
                        HStack{
                            Text(viewModel.isComplete ? "Complete":"Mark As Complete")
                                .padding(.horizontal)
                        }
                        .frame(height: 30)
                        .foregroundColor(viewModel.isComplete ? .white : .black)
                    }
                    .background(viewModel.isComplete ? Color(.systemRed) : Color(.clear))
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(viewModel.isComplete ? Color(.systemRed) : .black, lineWidth: 1))
                    
                    .disabled(!viewModel.isEditingEnabled)
                    .padding(.top, 10)
                }
            }
        }
        .frame(height: 190)
        .padding(.horizontal)
        .padding(.top, 15)
        .padding(.bottom, 10)
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $viewModel.pickerItem)
        .alert(isPresented:$showSaveAlert) {
                    Alert(
                        title: Text(alertText),
                        primaryButton: .destructive(Text(alertDestrucText)) {
                            savePostChanges()
                        },
                        secondaryButton: .cancel()
                    )
                }
        
    }
    
    func savePostChanges(){
        Task {
            self.isPostUpdating = true
            await viewModel.updateUserPostChanges(fromPost: post)
            self.isPostUpdating = false
            if(!viewModel.saveSuccessful){
                alertText = "Failed to Upload new Photo"
                alertDestrucText = "Try Again"
                showSaveAlert.toggle()
            } else {
                //Letting go of selected Edit post
                self.selectedPostId = nil
            }
        }
    }
}

//struct UserPostCellView_Previews: PreviewProvider {
//    @State private var id: String? = nil
//    static var previews: some View {
//        UserPostCellView(post: Post.MOCK_POSTS[1], selectedPostId: $id)
//    }
//
//}
