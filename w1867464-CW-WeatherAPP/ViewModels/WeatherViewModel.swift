//
//  WeatherViewModel.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-12.
//

import Foundation

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

    init() {
        // Retrieve the saved city or use "Colombo" as the default
        cityName = UserDefaults.standard.string(forKey: "SelectedCity") ?? "Colombo"
    }
    
//    func fetchOneCallWeather(lat: Double, lon: Double) {
//        self.isLoading = true
//        guard let url = URL(string: "\(APIConfig.oneCallBaseURL)?lat=\(lat)&lon=\(lon)&appid=\(APIConfig.apiKey)&units=metric") else {
//            print("Invalid One Call API URL")
//            return
//        }
    
    func fetchWeather(for city: String) {
        self.isLoading = true
        guard let url = URL(string: "\(APIConfig.weatherBaseURL)?q=\(city)&appid=\(APIConfig.apiKey)&units=metric") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let rawJSON = String(data: data, encoding: .utf8)
                print("Raw JSON Response: \(rawJSON ?? "No Data")")
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    print("Decoded JSON Response: \(decodedResponse)")
                    DispatchQueue.main.async {
                        self.cityName = decodedResponse.name
                        self.description = decodedResponse.weather.first?.description.capitalized ?? ""
                        self.temperature = "\(Int(decodedResponse.main.temp))°"
                        self.highTemp = "H: \(Int(decodedResponse.main.tempMax))°"
                        self.lowTemp = "L: \(Int(decodedResponse.main.tempMin))°"
                        self.averageTemp = String(format: "+ %.1f°", (decodedResponse.main.tempMax + decodedResponse.main.tempMin) / 2)
                        self.pressure = "\(decodedResponse.main.pressure ?? 0)"
                        self.humidity = "\(decodedResponse.main.humidity ?? 0)"
                        self.sunrise = self.convertUnixTimeTo24Hour(decodedResponse.sys.sunrise)
                        self.sunset = self.convertUnixTimeTo24Hour(decodedResponse.sys.sunset)
                        self.visibility = String(format: "%.0f km", Double(decodedResponse.visibility) / 1000)
                        
                        if let feelsLike = decodedResponse.main.feelsLike {
                            self.feelsLike = "\(String(format: "%.1f", feelsLike))°"
                        } else {
                            self.feelsLike = "--°"
                        }
                        
                        self.windSpeed = "\(decodedResponse.wind.speed)"
                        
                        if let gust = decodedResponse.wind.gust {
                            self.windGust = "\(gust)"
                        }
                        
                        if let deg = decodedResponse.wind.deg {
                            self.windDirection = "\(deg)"
                        }
                        
                        // Determine if it's day or night
                        if let icon = decodedResponse.weather.first?.icon {
                            self.isDaytime = icon.contains("d") // "d" for day, "n" for night
                        }
                        self.isLoading = false
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func searchCities(query: String, completion: @escaping ([String]) -> Void) {
        guard !query.isEmpty else {
            completion([])
            return
        }
        
        guard let url = URL(string: "\(APIConfig.geoCodeBaseURL)?q=\(query)&appid=\(APIConfig.apiKey)&units=metric") else {
            print("Invalid GeoCode URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CitiesResponse.self, from: data)
                    let cityNames = decodedResponse.list.compactMap { $0.name }
                    DispatchQueue.main.async {
                        completion(cityNames)
                    }
                } catch {
                    print("Failed to decode city search data: \(error)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }.resume()
    }
    
    private func convertUnixTimeTo24Hour(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
