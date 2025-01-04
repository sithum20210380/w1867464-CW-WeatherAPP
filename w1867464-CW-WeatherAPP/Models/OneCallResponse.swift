//
//  Untitled.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2025-01-02.
//

import Foundation

struct OneCallResponse: Codable {
    let current: Current
    let daily: [Daily]
    let timezone: String
    
    struct Current: Codable {
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double?
        let weather: [Weather]
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
    
    struct Daily: Codable {
        let temp: Temperature
        let weather: [Weather]
        
        struct Temperature: Codable {
            let min: Double
            let max: Double
        }
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}
