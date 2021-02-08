//
//  MapView.swift
//  travel
//
//  Created by Дмитрий on 24.01.2021.
//

import SwiftUI
import MapKit

struct MapView: View, ModelScreen {
    
    static var icon: String = "map.fill"
    var user: UserModel
    @ObservedObject var place = Place()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4799417, longitude: -122.449833),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State var places = [PlaceModel]()
    
    
    var body: some View {
        
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), tint: Color.red)
        }
        .ignoresSafeArea(.all, edges: .all)
        .onTapGesture {
            print (region)
        }.onAppear {
            getAllPlaces ()
        }
    }
    
    
    
    func getAllPlaces () {
        place.getAllPlaces(user.getUser()!) { (list) in
            places = list
            if let lastplace = list.last {
                region.center.latitude = lastplace.latitude
                region.center.latitude = lastplace.longitude
            }
        }
    }
    
}
