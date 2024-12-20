//
//  HumidityPressureView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-20.
//

import SwiftUI

struct HumidityPressureView: View {
    let humidity: String
    let pressure: String
    var isDaytime: Bool
    
    var body: some View {
        VStack{
            HStack(spacing: 10) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "drop.fill")
                        Text("HUMIDITY")
                    }
                    .opacity(0.6)
                    .padding(.bottom, 5)
                    Text("\(humidity)%")
                        .font(.system(size: 30))
                        .fontWeight(.medium)
                    Spacer()
                    Text("the dew point is \(humidity)° right now.")
                        
                    
                }
                .foregroundColor(.white)
                .padding()
                .padding(.trailing, 40)
                .frame(width: 180, height: 200)
                .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
                .cornerRadius(15)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "eye.fill")
                        Text("PRESSURE")
                    }.opacity(0.6)
                        .padding(.bottom, 5)
                    Spacer()
                    VStack(alignment: .center) {
                        Text(pressure)
                            .font(.system(size: 30))
                            .fontWeight(.medium)
                        Text("hPa")
                            .font(.system(size: 26))
                            .fontWeight(.medium)
                    }
                    .padding(.leading, 40)
                    .padding(.bottom, 60)
                        
                }
                .foregroundColor(.white)
                .padding(.top)
                .padding(.leading,-30)
                .frame(width: 180, height: 200)
                .background(isDaytime ? Color.blue.opacity(0.5) : Color.black.opacity(0.5))
                .cornerRadius(15)
            }
        }
    }
}

#Preview {
    HumidityPressureView(humidity: "80", pressure: "1013", isDaytime: true)
}
