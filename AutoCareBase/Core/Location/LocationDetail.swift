//
//  LocationDetail.swift
//  AutoCareBase
//
//  Created by Luis Santos on 7/8/24.
//

import SwiftUI
import MapKit

struct LocationDetail: View {
    var body: some View {
        VStack{
            Map(coordinateRegion: .constant(region), showsUserLocation: false)
                .frame(height: UIScreen.main.bounds.width * (2/3))
            Image("AustinWeirdAutosLogo")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * (2/3),
                       height: UIScreen.main.bounds.width * (2/3))
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .offset(y: -100)
                .shadow(radius: 9)
                .padding(.bottom, -100)
            
            VStack(alignment: .leading) {
                Text("Austin Weird Autos")
                    .font(.title)
                
                HStack {
                    Text("9706 Middle Fiskville Rd")
                    Spacer()
                    Text("Austin, TX")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("Option: Mission Statement")
                    .font(.title2)
                Text("Mission statement text goes here or we could put an email address or link to website")
            }
            .padding()
            
            Spacer()
            
        }
    }
}
private var region: MKCoordinateRegion {
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.360_330, longitude: -97.684_799),
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
}

//.onTapGesture(count: 2) {
//                    showThis.toggle()
//                    print("onTapGesture")
//                }

struct LocationDetail_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetail()
    }
}
