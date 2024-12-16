//
//  PrecipitationMapView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-14.
//

import SwiftUI
import MapKit

struct PrecipitationMapView: View {
    @Binding var region: MKCoordinateRegion
    var isDaytime: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "umbrella.fill")
                Text("PRECIPITATION")
            }
            .opacity(0.6)
            Map(coordinateRegion: $region, interactionModes: .zoom)
                .frame(height: 200)
                .cornerRadius(10)
        }
        .foregroundColor(.white)
        .padding()
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

