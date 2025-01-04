//
//  TenDayForecastSection.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-14.
//

import SwiftUI

struct TenDayForecastSection: View {
    @ObservedObject var viewModel: WeatherViewModel
    var isDaytime: Bool
    
    private func getDayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full day name
        let dayName = formatter.string(from: date)
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        return dayName
    }
    
    private func getWeatherIcon(from apiIcon: String) -> String {
        // Convert API weather icon codes to SF Symbols
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
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                Text("10 Day Forecast")
                    .foregroundColor(.white)
            }
            .opacity(0.6)
            
            Divider()
                .background(Color.white.opacity(0.6))
            ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 8) {
                                ForEach(Array(viewModel.dailyForecasts.prefix(10))) { forecast in
                                    DailyForecastRowView(
                                        day: getDayName(from: forecast.date),
                                        weatherIcon: getWeatherIcon(from: forecast.icon),
                                        minTemp: String(format: "%.0f°", forecast.minTemp),
                                        maxTemp: String(format: "%.0f°", forecast.maxTemp),
                                        precipitationChance: forecast.precipitation
                                    )
                                }
                            }
                        }
                    }
        .foregroundColor(.white)
        .padding()
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct DailyForecastRowView: View {
    var day: String
    var weatherIcon: String
    var minTemp: String
    var maxTemp: String
    var precipitationChance: Double
    
    var body: some View {
        HStack(spacing: 20) {
            Text(day)
                .frame(width: 100, alignment: .leading)
            
            VStack {
                Image(systemName: weatherIcon)
                    .symbolEffect(.breathe)
                    .font(.system(size: 25))
                
                if precipitationChance > 0 {
                    Text("\(Int(precipitationChance))%")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                }
            }
            
            HStack{
                Text(minTemp)
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 80, height: 4)
                Text(maxTemp)
            }
            
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TenDayForecastSection(viewModel: WeatherViewModel(), isDaytime: true)
}
