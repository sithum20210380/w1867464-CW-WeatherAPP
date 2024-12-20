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
    @EnvironmentObject var viewModel: WeatherViewModel
    @StateObject private var mapViewModel = MapViewModel()
    
    @State private var selectedCity = "Moratuwa"
    @State private var showSearchView = false
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    if viewModel.isDaytime {
                        VideoBackgroundView(videoName: "clouds", videoType: "mp4")
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .edgesIgnoringSafeArea(.all)
                            .overlay(Color.blue.opacity(0.5))
                    } else {
                        VideoBackgroundView(videoName: "night", videoType: "mp4")
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .edgesIgnoringSafeArea(.all)
                            .overlay(Color.white.opacity(0.1))
                    }
                    
                    VStack {
                        if viewModel.isLoading {
                            SkeletonView()
                        }else {
                            WeatherHeaderView(
                                cityName: viewModel.cityName,
                                temperature: viewModel.temperature,
                                description: viewModel.description
                            )
                            ScrollView(.vertical, showsIndicators: false){
                                DailyForecastSection(isDaytime: viewModel.isDaytime)
                                    .padding(.bottom, -26)
                                TenDayForecastSection(isDaytime: viewModel.isDaytime)
                                    .padding(.bottom, -26)
                                PrecipitationMapView(region: $region,isDaytime: viewModel.isDaytime)
                                    .padding(.bottom, -9)
                                SummaryView(
                                    avgTemp: viewModel.averageTemp,
                                    feelsLike: viewModel.feelsLike,
                                    isDaytime: viewModel.isDaytime
                                )
                                .padding(.bottom, -9)
                                WindView(
                                    windSpeed: viewModel.windSpeed,
                                    windDirection: viewModel.windDirection,
                                    windGust: viewModel.windGust,
                                    isDaytime: viewModel.isDaytime)
                                .padding(.bottom, -9)
                                UVSunsetView(
                                    sunset: viewModel.sunset,
                                    sunrise: viewModel.sunrise,
                                    isDaytime: viewModel.isDaytime
                                )
                                .padding(.bottom, 6)
                                PrecipVisibilityView(
                                    visibility: viewModel.visibility,
                                    isDaytime: viewModel.isDaytime
                                )
                                .padding(.bottom, -9)
                                WaxingCrescent(
                                    illumination: "10%",
                                    moonset: "20:41",
                                    nextFullMoon: "11 Days",
                                    isDaytime: viewModel.isDaytime
                                )
                                .padding(.bottom, -9)
                                HumidityPressureView(
                                    humidity: viewModel.humidity,
                                    pressure: viewModel.pressure,
                                    isDaytime: viewModel.isDaytime
                                )
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: viewModel.cityName)
            mapViewModel.updateRegion(for: "Moratuwa")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherViewModel())
}

