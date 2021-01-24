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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4799417, longitude: -122.449833),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        Map(coordinateRegion: $region).ignoresSafeArea(.all, edges: .all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
