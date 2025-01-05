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
    @StateObject private var connectivityManager = ConnectivityManager()
    
    @State private var selectedCity = "Moratuwa"
    @State private var showSearchView = false
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                if connectivityManager.hasError {
                    ErrorView(message: connectivityManager.errorMessage)
                } else {
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
                                } else {
                                    WeatherHeaderView(
                                        cityName: viewModel.cityName,
                                        temperature: viewModel.temperature,
                                        description: viewModel.description
                                    )
                                    ScrollView(.vertical, showsIndicators: false) {
                                        HourlyForecastSection(viewModel: viewModel, isDaytime: viewModel.isDaytime)
                                            .padding(.bottom, -26)
                                        TenDayForecastSection(viewModel: viewModel, isDaytime: viewModel.isDaytime)
                                            .padding(.bottom, -26)
                                        PrecipitationMapView(region: $region, isDaytime: viewModel.isDaytime)
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
                                        .padding(.bottom, -9)
                                        AirQualitySection(viewModel: viewModel, isDaytime: viewModel.isDaytime)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                   await viewModel.getCoordinatesForCity(viewModel.cityName)
                   await mapViewModel.updateRegion(for: "Moratuwa")
               }
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            
            if message.contains("Settings") {
                Button("Open Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
        .environmentObject(WeatherViewModel())
}
