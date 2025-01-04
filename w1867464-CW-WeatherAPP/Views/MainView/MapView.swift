//
//  MapView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 45, longitudeDelta: 45)
    )
    
    var body: some View {
        Map {
            ForEach(viewModel.favoriteCities) { city in
                Marker(city.name, coordinate: city.coordinate)
                    .tint(.red)
            }
        }
        .onAppear {
            if let firstCity = viewModel.favoriteCities.first {
                region.center = firstCity.coordinate
            }
        }
    }
}

#Preview {
    MapView(viewModel: WeatherViewModel())
}
