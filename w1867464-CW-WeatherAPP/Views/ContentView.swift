//
//  ContentView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-11.
//

import SwiftUI
import AVKit
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var mapViewModel = MapViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    VideoBackgroundView(videoName: viewModel.isDaytime ? "night" : "clouds", videoType: "mp4")
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(viewModel.isDaytime ? Color.blue.opacity(0.5) : Color.white.opacity(0.1))
                    
                    VStack {
                        WeatherHeaderView(
                            cityName: viewModel.cityName,
                            temperature: viewModel.temperature,
                            description: viewModel.description
                        )
                        
                        ScrollView(.vertical, showsIndicators: false){
                            DailyForecastSection(isDaytime: viewModel.isDaytime)
                                .padding(.bottom, -25)
                            TenDayForecastSection(isDaytime: viewModel.isDaytime)
                                .padding(.bottom, -25)
                            PrecipitationMapView(region: $region,isDaytime: viewModel.isDaytime)
                                .padding(.bottom, -8)
                            SummaryView(
                                avgTemp: viewModel.averageTemp,
                                feelsLike: viewModel.feelsLike,
                                isDaytime: viewModel.isDaytime
                            )
                            .padding(.bottom, -8)
                            WindView(
                                windSpeed: viewModel.windSpeed,
                                windDirection: viewModel.windDirection,
                                windGust: viewModel.windGust,
                                isDaytime: viewModel.isDaytime)
                        }
                        
                        Spacer()
                    }
                    
                }
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: "Moratuwa")
            mapViewModel.updateRegion(for: "Moratuwa")
        }
    }
}

#Preview {
    ContentView()
}

