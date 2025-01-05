//
//  WeatherResponse.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-12.
//

import Foundation

struct WeatherResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: Current
    let minutely: [Minutely]?
    let hourly: [Hourly]
    let daily: [Daily]
    
    struct Current: Codable {
        let dt: TimeInterval
        let sunrise: TimeInterval
        let sunset: TimeInterval
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double?
        let weather: [Weather]
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Minutely: Codable {
        let dt: TimeInterval
        let precipitation: Double
    }
    
    struct Hourly: Codable {
        let dt: TimeInterval
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double?
        let weather: [Weather]
    }
    
    struct Daily: Codable {
        let dt: TimeInterval
        let sunrise: TimeInterval
        let sunset: TimeInterval
        let moonrise: TimeInterval
        let moonset: TimeInterval
        let moon_phase: Double
        let temp: Temperature
        let feels_like: FeelsLike
        let pressure: Int
        let humidity: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double?
        let weather: [Weather]
        let clouds: Int
        let pop: Double
        let uvi: Double
        let summary: String
    }
    
    struct Temperature: Codable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    
    struct FeelsLike: Codable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
}
