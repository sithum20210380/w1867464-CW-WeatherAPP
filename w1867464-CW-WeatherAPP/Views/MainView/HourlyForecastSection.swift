//
//  DailyForecastSection.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-14.
//

import SwiftUI

struct HourlyForecastSection: View {
    @ObservedObject var viewModel: WeatherViewModel
    var isDaytime: Bool
    
    private func getHourString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "ha"
            return formatter.string(from: date).lowercased()
        }
    
    private func getWeatherIcon(from apiIcon: String) -> String {
        switch apiIcon {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.sun.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.hourlyForecastSummary)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            
            Divider()
                .background(Color.white.opacity(0.6))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    ForEach(viewModel.hourlyForecasts) { forecast in
                        HourlyForecastView(
                            day: getHourString(from: forecast.date),
                            weatherIcon: getWeatherIcon(from: forecast.icon),
                            temp: String(format: "%.0f°", forecast.temp)
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct HourlyForecastView: View {
    var day: String
    var weatherIcon: String
    var temp: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(day)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
            
            Image(systemName: weatherIcon)
                .symbolEffect(.breathe)
                .font(.system(size: 25))
                .foregroundColor(.white)
            
            Text(temp)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
        }
    }
}

#Preview {
    HourlyForecastSection(viewModel: WeatherViewModel(), isDaytime: true)
}
