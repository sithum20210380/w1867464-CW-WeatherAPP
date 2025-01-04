//
//  WeatherViewModel.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-12.
//

import Foundation
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var cityName: String {
        didSet {
            UserDefaults.standard.set(cityName, forKey: "SelectedCity")
        }
    }
    
    @Published var temperature: String = "--°"
    @Published var averageTemp: String = "--°"
    @Published var highTemp: String = "--°"
    @Published var lowTemp: String = "--°"
    @Published var description: String = "Loading..."
    @Published var feelsLike: String = "--°"
    @Published var icon: String = ""
    @Published var windSpeed: String = "--"
    @Published var windDirection: String = ""
    @Published var windGust: String = "--"
    @Published var sunrise: String = "--:--"
    @Published var sunset: String = "--:--"
    @Published var visibility: String = "--"
    @Published var pressure: String = "--"
    @Published var humidity: String = "--"
    @Published var illumination: String = "--"
    @Published var moonset: String = "--"
    @Published var nextFullMoon: String = ""
    @Published var isDaytime: Bool = true
    @Published var isLoading: Bool = true
    @Published var searchResults: [String] = []
    @Published var hourlyForecasts: [HourlyForecast] = []
    @Published var dailyForecasts: [DailyForecast] = []
    @Published var forecastSummary: String = "Loading forecast..."
    @Published var hourlyForecastSummary: String = "Loading forecast..."
    
    @Published var favoriteCities: [FavoriteCity] = [] {
        didSet {
            saveFavorites()
        }
    }
    
    private let geocoder = CLGeocoder()
    
    struct HourlyForecast: Identifiable {
        let id = UUID()
        let date: Date
        let temp: Double
        let icon: String
    }
    
    struct DailyForecast: Identifiable {
        let id = UUID()
        let date: Date
        let minTemp: Double
        let maxTemp: Double
        let icon: String
        let precipitation: Double
    }
    
    init() {
        cityName = UserDefaults.standard.string(forKey: "SelectedCity") ?? "Colombo"
        loadFavorites()
        getCoordinatesForCity(cityName)
    }
    
    func getCoordinatesForCity(_ city: String) {
        geocoder.geocodeAddressString(city) { [weak self] placemarks, error in
            if let location = placemarks?.first?.location {
                self?.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func addToFavorites(_ cityName: String) {
        // Use geocoder to get coordinates before adding to favorites
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { [weak self] placemarks, error in
            guard let self = self,
                  let location = placemarks?.first?.location else { return }
            
            let newCity = FavoriteCity(
                name: cityName,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            DispatchQueue.main.async {
                if !self.favoriteCities.contains(where: { $0.name == cityName }) {
                    self.favoriteCities.append(newCity)
                }
            }
        }
    }
    
    func removeFromFavorites(_ cityName: String) {
        favoriteCities.removeAll { $0.name == cityName }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteCities) {
            UserDefaults.standard.set(encoded, forKey: "FavoriteCities")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "FavoriteCities"),
           let decoded = try? JSONDecoder().decode([FavoriteCity].self, from: data) {
            favoriteCities = decoded
        }
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        self.isLoading = true
        let urlString = "\(APIConfig.oneCallBaseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(APIConfig.oneCallAPIKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Update current weather
                        self.temperature = "\(Int(decodedResponse.current.temp))°"
                        self.description = decodedResponse.current.weather.first?.description.capitalized ?? ""
                        self.feelsLike = "\(Int(decodedResponse.current.feels_like))°"
                        
                        // Update daily temperatures
                        if let today = decodedResponse.daily.first {
                            self.highTemp = "H: \(Int(today.temp.max))°"
                            self.lowTemp = "L: \(Int(today.temp.min))°"
                            self.averageTemp = String(format: "+ %.1f°", (today.temp.max + today.temp.min) / 2)
                        }
                        
                        // Update other metrics
                        self.pressure = "\(decodedResponse.current.pressure)"
                        self.humidity = "\(decodedResponse.current.humidity)"
                        self.visibility = String(format: "%.0f km", Double(decodedResponse.current.visibility) / 1000)
                        self.windSpeed = "\(decodedResponse.current.wind_speed)"
                        if let gust = decodedResponse.current.wind_gust {
                            self.windGust = "\(gust)"
                        }
                        self.windDirection = "\(decodedResponse.current.wind_deg)"
                        
                        // Update sun times
                        self.sunrise = self.convertUnixTimeTo24Hour(decodedResponse.current.sunrise)
                        self.sunset = self.convertUnixTimeTo24Hour(decodedResponse.current.sunset)
                        
                        // Update hourly forecasts (next 24 hours)
                        self.hourlyForecasts = decodedResponse.hourly.prefix(24).map { hourly in
                            HourlyForecast(
                                date: Date(timeIntervalSince1970: hourly.dt),
                                temp: hourly.temp,
                                icon: hourly.weather.first?.icon ?? "cloud.fill"
                            )
                        }
                        
                        // Update daily forecasts
                        self.dailyForecasts = decodedResponse.daily.prefix(10).map { daily in
                            DailyForecast(
                                date: Date(timeIntervalSince1970: daily.dt),
                                minTemp: daily.temp.min,
                                maxTemp: daily.temp.max,
                                icon: daily.weather.first?.icon ?? "cloud.fill",
                                precipitation: daily.pop * 100 // Convert to percentage
                            )
                        }
                        
                        // Update forecast summary
                        if let todayForecast = decodedResponse.daily.first {
                            self.forecastSummary = "\(todayForecast.summary) Wind gusts are up to \(Int(todayForecast.wind_gust ?? 0))km/h."
                        }
                        
                        if let todayForecast = decodedResponse.daily.first {
                                                    self.hourlyForecastSummary = todayForecast.summary
                                                }
                        
                        // Determine if it's daytime
                        if let icon = decodedResponse.current.weather.first?.icon {
                            self.isDaytime = icon.contains("d")
                        }
                        
                        self.isLoading = false
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                    self.isLoading = false
                }
            }
        }.resume()
    }
    
    //    func searchCities(query: String, completion: @escaping ([String]) -> Void) {
    //        guard !query.isEmpty else {
    //            completion([])
    //            return
    //        }
    //
    //        guard let url = URL(string: "\(APIConfig.geoCodeBaseURL)?q=\(query)&appid=\(APIConfig.apiKey)&units=metric") else {
    //            print("Invalid GeoCode URL")
    //            completion([])
    //            return
    //        }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let data = data {
    //                do {
    //                    let decodedResponse = try JSONDecoder().decode(CitiesResponse.self, from: data)
    //                    let cityNames = decodedResponse.list.compactMap { $0.name }
    //                    DispatchQueue.main.async {
    //                        completion(cityNames)
    //                    }
    //                } catch {
    //                    print("Failed to decode city search data: \(error)")
    //                    DispatchQueue.main.async {
    //                        completion([])
    //                    }
    //                }
    //            }
    //        }.resume()
    //    }
    
    private func convertUnixTimeTo24Hour(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
