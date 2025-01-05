//
//  AirQualityView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2025-01-05.
//

import SwiftUI

struct AirQualitySection: View {
    @ObservedObject var viewModel: WeatherViewModel
    var isDaytime: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "thermometer.low")
                Text("Air Quality")
            }.opacity(0.6)
            .foregroundColor(.white)
            
            Divider()
                .background(Color.white.opacity(0.6))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    AirQualityCardView(title: "CO", value: viewModel.coLevel, isDaytime: viewModel.isDaytime)
                    AirQualityCardView(title: "NO2", value: viewModel.no2Level, isDaytime: viewModel.isDaytime)
                    AirQualityCardView(title: "O3", value: viewModel.o3Level, isDaytime: viewModel.isDaytime)
                    AirQualityCardView(title: "SO2", value: viewModel.so2Level, isDaytime: viewModel.isDaytime)
                    AirQualityCardView(title: "AQI", value: viewModel.airQualityIndex, isDaytime: viewModel.isDaytime)
                    AirQualityCardView(title: "PM2.5", value: viewModel.pm25Level, isDaytime: viewModel.isDaytime)
                    AirQualityCardView(title: "PM10", value: viewModel.pm10Level, isDaytime: viewModel.isDaytime)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct AirQualityCardView: View {
    var title: String
    var value: String
    var isDaytime: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
            
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .padding(8)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
        }
        .frame(width: 100)
        .padding()
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
    }
}

#Preview {
    AirQualitySection(viewModel: WeatherViewModel(), isDaytime: true)
}
