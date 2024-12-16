//
//  DailyForecastSection.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-14.
//

import SwiftUI

struct DailyForecastSection: View {
    var isDaytime: Bool
    
    var body: some View {
        VStack {
            Text("Cloudy conditions will continue for the rest of the day. Wind gusts are up to 17km/h.")
                .foregroundColor(.white)
            Divider()
            ScrollView(.horizontal) {
                HStack(spacing: 40) {
                    dailyforecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                    dailyforecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                    dailyforecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                    dailyforecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                    dailyforecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                    dailyforecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                }
            }
        }
        .padding()
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct dailyforecastView: View{
    var day: String
    var weatherIcon: String
    var temp: String
    
    var body: some View {
        VStack{
            Text(day)
                .foregroundColor(.white)
            Image(systemName: weatherIcon)
                .symbolEffect(.breathe)
                .font(.system(size: 30))
                .foregroundColor(.white)
            Text(temp)
                .foregroundColor(.white)
        }
    }
    
}

