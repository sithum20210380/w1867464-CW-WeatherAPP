//
//  WeatherViewModel.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-12.
//

import SwiftUI
import CoreLocation

class WeatherViewModel: ObservableObject {
    
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
    @Published var uvIndex: String = "--"
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
    
    // Air Pollution Properties
    @Published var airQualityIndex: String = "--"
    @Published var coLevel: String = "--"
    @Published var no2Level: String = "--"
    @Published var o3Level: String = "--"
    @Published var so2Level: String = "--"
    @Published var pm25Level: String = "--"
    @Published var pm10Level: String = "--"
    
    @Published var cityName: String {
        didSet {
            UserDefaults.standard.set(cityName, forKey: "SelectedCity")
        }
    }
    
    @Published var favoriteCities: [FavoriteCity] = [] {
        didSet {
            saveFavorites()
        }
    }
    
    @AppStorage("FavoriteCitiesData") private var favoriteCitiesData: Data?
    
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
        Task {
            await getCoordinatesForCity(cityName)
        }
    }
    
    func getCoordinatesForCity(_ city: String) async {
        do {
            let placemarks = try await geocodeCity(city)
            if let location = placemarks.first?.location {
                await fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                await fetchAirPollutionData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        } catch {
            print("Failed to get coordinates: \(error)")
        }
    }
    
    private func geocodeCity(_ city: String) async throws -> [CLPlacemark] {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(city) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: placemarks ?? [])
                }
            }
        }
    }
    
    func addToFavorites(_ cityName: String) {
        // Check if city already exists in favorites
        guard !favoriteCities.contains(where: { $0.name == cityName }) else {
            return
        }
        
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
                self.favoriteCities.append(newCity)
            }
        }
    }
    
    func removeFromFavorites(_ cityName: String) {
        favoriteCities.removeAll { $0.name == cityName }
    }
    
    private func saveFavorites() {
        do {
            let encodedData = try JSONEncoder().encode(favoriteCities)
            favoriteCitiesData = encodedData
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
    
    private func loadFavorites() {
        guard let data = favoriteCitiesData else { return }
        
        do {
            favoriteCities = try JSONDecoder().decode([FavoriteCity].self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
            favoriteCities = []
        }
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async {
        DispatchQueue.main.async {
                self.isLoading = true
            }
        let urlString = "\(APIConfig.oneCallBaseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(APIConfig.oneCallAPIKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                        print("Invalid URL")
                    }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.updateWeatherUI(with: decodedResponse)
                self.isLoading = false
            }
        } catch {
            print("Failed to fetch weather: \(error)")
            self.isLoading = false
        }
    }
    
    func fetchAirPollutionData(latitude: Double, longitude: Double) async {
        let airPollutionURLString = "\(APIConfig.airPollutionBaseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(APIConfig.oneCallAPIKey)&units=metric"
        
        guard let url = URL(string: airPollutionURLString) else {
            print("Invalid Air Pollution URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let airPollutionResponse = try JSONDecoder().decode(AirPollutionResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.updateAirPollutionUI(with: airPollutionResponse)
            }
        } catch {
            print("Failed to fetch air pollution data: \(error)")
        }
    }
    
    private func updateWeatherUI(with response: WeatherResponse) {
        // Update current weather
        self.temperature = "\(Int(response.current.temp))°"
        self.description = response.current.weather.first?.description.capitalized ?? ""
        self.feelsLike = "\(Int(response.current.feels_like))°"
        
        // Update daily temperatures
        if let today = response.daily.first {
            self.highTemp = "H: \(Int(today.temp.max))°"
            self.lowTemp = "L: \(Int(today.temp.min))°"
            self.averageTemp = String(format: "+ %.1f°", (today.temp.max + today.temp.min) / 2)
            self.hourlyForecastSummary = today.summary
        }
        
        // Update other metrics
        self.pressure = "\(response.current.pressure)"
        self.humidity = "\(response.current.humidity)"
        self.visibility = String(format: "%.0f km", Double(response.current.visibility) / 1000)
        self.windSpeed = "\(response.current.wind_speed)"
        if let gust = response.current.wind_gust {
            self.windGust = "\(gust)"
        }
        self.windDirection = "\(response.current.wind_deg)"
        
        // Update sun times
        self.sunrise = self.convertUnixTimeTo24Hour(response.current.sunrise)
        self.sunset = self.convertUnixTimeTo24Hour(response.current.sunset)
        
        // Update UV Index
        self.uvIndex = "\(Int(response.current.uvi))"
        
        // Update hourly and daily forecasts
        self.hourlyForecasts = response.hourly.prefix(24).map {
            HourlyForecast(
                date: Date(timeIntervalSince1970: $0.dt),
                temp: $0.temp,
                icon: $0.weather.first?.icon ?? "cloud.fill"
            )
        }
        self.dailyForecasts = response.daily.prefix(10).map {
            DailyForecast(
                date: Date(timeIntervalSince1970: $0.dt),
                minTemp: $0.temp.min,
                maxTemp: $0.temp.max,
                icon: $0.weather.first?.icon ?? "cloud.fill",
                precipitation: $0.pop * 100 // Convert to percentage
            )
        }
        
        // Determine if it's daytime
        if let icon = response.current.weather.first?.icon {
            self.isDaytime = icon.contains("d")
        }
    }
    
    private func updateAirPollutionUI(with response: AirPollutionResponse) {
        if let pollution = response.list.first {
            self.airQualityIndex = "\(pollution.main.aqi)"
            self.coLevel = "\(pollution.components.co)"
            self.no2Level = "\(pollution.components.no2)"
            self.o3Level = "\(pollution.components.o3)"
            self.so2Level = "\(pollution.components.so2)"
            self.pm25Level = "\(pollution.components.pm2_5)"
            self.pm10Level = "\(pollution.components.pm10)"
        }
    }
    
    private func convertUnixTimeTo24Hour(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
