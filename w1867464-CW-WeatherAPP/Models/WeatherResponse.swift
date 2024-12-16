//
//  WeatherResponse.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-12.
//
import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
        let averageTemp: Double?
        let tempMin: Double
        let tempMax: Double
        let feelsLike: Double?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case averageTemp = "average_temperature"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case feelsLike = "feels_like"
        }
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
        let gust: Double?
        let deg: Double?
    }
}
