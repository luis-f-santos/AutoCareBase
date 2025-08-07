//
//  PostDetailView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/27/24.
//

import SwiftUI
import Foundation
import Kingfisher

struct PostDetailView: View {
    var post: Post
    @Binding var didUpdatePublic: Bool
    @State var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var imageFrameHeight: CGFloat = 300
    @State var scale = 1.0
    @State var lastScale = 1.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    @State var enableDragGesture: Bool = false
    var minScale = 1.0
    var maxScale = 5.0

    @StateObject var viewModel = PostDetailPostViewModel()
    
    var body: some View {
        VStack {
            Capsule()
                    .fill(Color.secondary)
                    .frame(width: 30, height: 3)
                    .padding(10)
            VStack {
                TabView{
                    ForEach(0..<post.imageURLsArray!.count, id: \.self) { i in
                        KFImage(URL(string: post.imageURLsArray![i]))
                            .placeholder{ProgressView().tint(.white)}
                            .resizable()
                            .gesture(drag, isEnabled: enableDragGesture)
                            .gesture(doubleTap)
                            .offset(offset)
                            .scaledToFill()
                            .frame(width: screenWidth, height: imageFrameHeight)
                            .scaleEffect(scale)
                            .clipped()
                            .gesture(magnification)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .frame(width: UIScreen.main.bounds.width, height: 300)
            .background(.black)
            
            Text(post.description)
                .padding(.top, 36)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            if(!post.isPublic){
                Text(viewModel.shareDescription)
                    .padding(.top, 36)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
                    .font(.caption)
                Button {
                    Task {
                        self.didUpdatePublic = await viewModel.shareBtnTapped(postID: post.id)
                    }
                } label: {
                    HStack{
                        Text("Share")
                    }
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .padding(.horizontal)
                }
                .background(Color(.systemRed))
                .cornerRadius(6)
                .disabled(viewModel.disableShareButton)
            }
            Spacer()
        }
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged{ value in
                withAnimation(.spring()) {
                    offset = handleOffsetChange(value.translation)
                }
            }
            .onEnded{ value in
                lastOffset = offset
            }
    }
    
    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .onEnded{
                withAnimation(.spring()) {
                    scale = 1.0
                    lastScale = 1.0
                    offset = .zero
                    lastOffset = .zero
                    enableDragGesture = false
                }
            }
    }
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                adjustScale(from: state)
            }
            .onEnded { state in
                withAnimation {
                    validateScaleLimits()
                }
                if(scale > 1.0 || scale < 1.0){
                    enableDragGesture = true
                } else if (minScale == scale){
                    offset = .zero
                    lastOffset = .zero
                    enableDragGesture = false
                }
                lastScale = 1.0
            }
    }
    
    func adjustScale(from state: MagnificationGesture.Value) {
        let delta = state / lastScale
        scale *= delta
        lastScale = state
    }
    func getMiniumScaledAllowed() -> CGFloat {
        return max(scale, minScale)
    }
    func gerMaximumAllowed() -> CGFloat {
        return min(scale, maxScale)
    }
    func validateScaleLimits(){
        scale = getMiniumScaledAllowed()
        scale = gerMaximumAllowed()
    }
    
    private func handleScaleChange(_ zoom: CGFloat) -> CGFloat {
        lastScale + zoom - (lastScale == 0 ? 0 : 1)
    }

    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        let multScale = 1.25
        newOffset.width = multScale * offset.width + lastOffset.width
        newOffset.height = multScale * offset.height + lastOffset.height

        return newOffset
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: Post.MOCK_POSTS[1], didUpdatePublic: .constant(false))
    }
}
