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
    
    private let _maxYear = 2026
    @State private var showProgessView = false
    @State private var isLoadingModels = false
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel = CreatePostViewModel()
    
    var body: some View {
        ZStack {
            VStack(){
                Text("Add Vehicle")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.accentColor)
                
                Picker("My Picker", selection: $viewModel.selectedMaker) {
                    ForEach(AUTO_MAKERS_ARRAY, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.wheel)
                
                VStack(spacing: 10) {
//                    TextField("Select Year", text: $viewModel.year)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack{
                        Text("Select Year:")
                            .foregroundColor(.accentColor)
                            .bold()
                        Picker("", selection: $viewModel.selectedYear) {
                            ForEach(0..<58, id: \.self) { number in
                                let year = formattedInteger(number)
                                Text(year).tag(year)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    HStack {
                        Text("Select Model:")
                            .foregroundColor(.accentColor)
                            .bold()
                        Picker("", selection: $viewModel.selectedModel) {
                            Text("").tag(nil as String?)
                            ForEach(viewModel.models, id: \.self) { model in
                                Text(model).tag(model as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        if isLoadingModels {
                            ProgressView()
                        } else { }
                    }
                }
                .onChange(of: [viewModel.selectedMaker]) { _ in
                    print("Maker Changed")
                    viewModel.models.removeAll()
                    viewModel.selectedModel = ""
                    viewModel.selectedYear = ""
                }
                .onChange(of: [viewModel.selectedYear]) { _ in
                    print("Changed")
                    viewModel.models.removeAll()
                    viewModel.selectedModel = ""
                    if (viewModel.selectedYear.isEmpty || viewModel.selectedMaker.isEmpty){ return }
                    Task {
                        isLoadingModels = true
                        try await fetchDataforAllTypes(withMake: viewModel.selectedMaker, andYear: viewModel.selectedYear)
                        isLoadingModels = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Text("Tap to add Image")
                    .padding(.top, 16)
                    .foregroundColor(.accentColor)
                
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
                .padding(.top, 16)
                .padding(.bottom, 8)
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
    
    func formattedInteger(_ number: Int) -> String {
            let year = _maxYear - number
            if year >= _maxYear {
                return ""
            }
            let formatter = NumberFormatter()
            formatter.numberStyle = .none // This removes grouping separators (commas)
            return formatter.string(from: NSNumber(value: year)) ?? "\(year)"
    }
    
    func fetchDataforAllTypes(withMake make: String, andYear year: String) async throws{
            if(make == "Scion"){
                try await fetchDataForScionMake(withYear: year)
                return
            }
            // Initiate all async operations concurrently
            async let carResult = fetchData(withMake: make, Year: year, ApiType: "car")
            async let suvResult = fetchData(withMake: make, Year: year, ApiType: "mpv")
            async let truckResult = fetchData(withMake: make, Year: year, ApiType: "truck")
            // Await their results
            let carResults = try await carResult
            let suvResults  = try await suvResult
            let truckResults  = try await truckResult
            // Merge arrays
            let combinedArray = carResults + truckResults + suvResults
            let uniqueElementsSet = Set(combinedArray)
            viewModel.models = Array(uniqueElementsSet).sorted(by: <)
        }
        
        func fetchDataForScionMake(withYear year: String) async throws{
            // Initiate all async operations concurrently
            async let carResult = fetchData(withMake: "Toyota", Year: year, ApiType: "car")
            async let suvResult = fetchData(withMake: "Toyota", Year: year, ApiType: "mpv")
            async let truckResult = fetchData(withMake: "Toyota", Year: year, ApiType: "truck")
            // Await their results
            let carResults = try await carResult
            let suvResults  = try await suvResult
            let truckResults  = try await truckResult
            
            let combinedArray = carResults + truckResults + suvResults
            // Traverse Toyota models looking for Scion models
            for model in combinedArray {
                if(model.contains("Scion")){
                    let separated = model.components(separatedBy: " ")
                    if let lastWord = separated.last {
                        print(lastWord)
                        viewModel.models.append(lastWord)
                    } else {
                        print("The string was empty or contained only spaces.")
                    }
                }
            }
        }

        func fetchData(withMake make: String, Year year: String, ApiType apiType: String) async throws -> [String]{
    //   "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/honda/modelyear/2015/vehicleType/mpv?format=json"

            var arrayResult: [String] = []
            let initURL  = "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/"
            let endPoint = initURL + make + "/modelyear/" + year + "/vehicleType/" + apiType + "?format=json"

            guard let url = URL(string: endPoint) else {
                fatalError("Invalid URL")
            }
            let (jsonData, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                for (key, value) in jsonObject {
                    if(key == "Count"){
                        print(value)
                    }
                    if(key == "Results"){
                        print(value)
                        if let nestedArray = value as? [Any] {
//                            self.returnedModels = self.returnedModels + "Models: "
                            for item in nestedArray {
                                if let data = try? JSONSerialization.data(withJSONObject: item, options: []) {
                                    if let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        for (key, value) in obj {
                                            // Process key and value
                                            if(key == "Model_Name"){
//                                                self.returnedModels = self.returnedModels + ", " +
//                                                ("\(value)")
                                                arrayResult.append(value as! String)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return arrayResult
        }
    
    
}


extension CreatePostView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.selectedYear.isEmpty && viewModel.selectedYear.count == 4
            && Int(viewModel.selectedYear) != nil
                && viewModel.selectedModel != nil
                    && viewModel.postImage != nil
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(userId: User.MOCK_USERS[0].id, addedPostSuccess: .constant(false))
    }
}
