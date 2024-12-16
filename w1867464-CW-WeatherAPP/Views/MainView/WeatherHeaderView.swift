//
//  WeatherHeaderView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-14.
//

import SwiftUI

struct WeatherHeaderView: View {
    let cityName: String
    let temperature: String
    let description: String
    
    var body: some View {
        VStack {
            Text("My Location")
                .foregroundColor(.white)
            Text(cityName)
                .font(.title)
                .foregroundColor(.white)
            Text(temperature)
                .font(.system(size: 70))
                .foregroundColor(.white)
            Text(description)
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                Text("H: 86°")
                    .foregroundColor(.white)
                Text("L: 82°")
                    .foregroundColor(.white)
            }
        }
    }
}
