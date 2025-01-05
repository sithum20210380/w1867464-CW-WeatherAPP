//
//  FavoriteCity.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2025-01-02.
//
import Foundation
import CoreLocation

struct FavoriteCity: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FavoriteCity, rhs: FavoriteCity) -> Bool {
        lhs.id == rhs.id
    }
}
