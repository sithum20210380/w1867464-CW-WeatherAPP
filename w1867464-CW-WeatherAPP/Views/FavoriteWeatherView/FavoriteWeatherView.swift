//
//  FavoriteWeatherView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2025-01-02.
//

import SwiftUI
import CoreLocation

struct FavoriteWeatherView: View {
    let cityName: String
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        NavigationStack {
            ContentView()
                .environmentObject(viewModel)
                .onAppear {
                    fetchWeatherForCity()
                }
        }
        
    }
    private func fetchWeatherForCity() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let location = placemarks?.first?.location {
                viewModel.getCoordinatesForCity(viewModel.cityName)
            }
        }
    }
}

#Preview {
    FavoriteWeatherView(cityName: "Colombo", viewModel: WeatherViewModel())
}
