//
//  TenDayForecastSection.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-14.
//

import SwiftUI

struct TenDayForecastSection: View {
    var isDaytime: Bool
    
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
            ScrollView(.vertical, showsIndicators: false) {
                tenDayForecastView(day: "Today", weatherIcon: "cloud.fill", temp: "84°")
                tenDayForecastView(day: "Tomorrow", weatherIcon: "cloud.sun.fill", temp: "86°")
                tenDayForecastView(day: "Monday", weatherIcon: "cloud.rain.fill", temp: "78°")
                // Add more days...
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct tenDayForecastView: View {
    var day: String
    var weatherIcon: String
    var temp: String
    
    var body: some View {
        VStack{
            HStack(spacing:20){
                Text(day)
                Image(systemName: weatherIcon)
                    .symbolEffect(.breathe)
                    .font(.system(size: 30))
                Text(temp)
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 100, height: 10)
                    .cornerRadius(10)
                Text(temp)
            }
        }
    }
}

