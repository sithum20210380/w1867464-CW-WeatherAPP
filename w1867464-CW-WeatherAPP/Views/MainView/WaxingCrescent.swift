//
//  WaxingCrescent.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-20.
//

import SwiftUI

struct WaxingCrescent: View {
    var illumination: String
    var moonset: String
    var nextFullMoon: String
    var isDaytime: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "umbrella.fill")
                Text("PRECIPITATION")
            }
            .padding(.bottom,5)
            .opacity(0.6)
            HStack{
                VStack(alignment: .leading) {
                    HStack{
                        Text("Illumination:")
                        Spacer()
                        Text(illumination)
                    }
                    Divider()
                    HStack{
                        Text("Moonset:")
                        Spacer()
                        Text(moonset)
                    }
                    Divider()
                    HStack{
                        Text("Next Full Moon:")
                        Spacer()
                        Text(nextFullMoon)
                    }
                    
                }
                VStack{
                    Image(systemName: "moon.fill")
                        .font(.system(size: 80))
                        .opacity(0.6)
                    
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

#Preview {
    WaxingCrescent(illumination: "10%", moonset: "20:41", nextFullMoon: "11 Days", isDaytime: true)
}
