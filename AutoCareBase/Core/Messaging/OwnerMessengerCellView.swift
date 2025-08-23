//
//  OwnerMessengerCellView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 8/12/25.
//

import SwiftUI

struct OwnerMessengerCellView: View {
    
    let name: String
    let initials: String
    let message: String
    
    init(recentMessage: RecentMessage) {
        self.name = recentMessage.userName
        self.initials = recentMessage.userInitials
        self.message = recentMessage.message
    }
//    public func getName() -> String {
//        return name
//    }
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Text(initials)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(Color(.systemGray3))
                    .clipShape(Circle())
                    .padding(.leading, 10)
                VStack(alignment: .leading){
                    Text(name)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                Spacer()
                Text("8mo")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .padding(10)
                    .padding(.trailing, 10)
                    .padding(.leading, 10)

            }
            .padding(.top, 8)
        }
    }
}

#Preview {
//    OwnerMessengerCellView(name:"Luis Santos")
}
