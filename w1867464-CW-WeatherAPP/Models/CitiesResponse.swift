//
//  CitiesResponse.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-20.
//

import Foundation

struct CitiesResponse: Codable {
    let list: [City]
    
    struct City: Codable {
        let name: String
        let country: String
        let coord: Coordinates
        
        struct Coordinates: Codable {
            let lat: Double
            let lon: Double
        }
    }
}
