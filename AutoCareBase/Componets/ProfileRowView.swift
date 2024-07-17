//
//  ProfileRowView.swift
//  AutoCareBase
//
//  Created by Luis Santos on 6/13/24.
//

import SwiftUI

struct ProfileRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            
        }
    }
}

struct ProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
