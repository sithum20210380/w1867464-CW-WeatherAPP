//
//  WeatherViewModel.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-12.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "Loading..."
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
    @Published var isDaytime: Bool = true
    
    func fetchWeather(for city: String) {
        guard let url = URL(string: "\(APIConfig.baseURL)?q=\(city)&appid=\(APIConfig.apiKey)&units=metric") else {
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
                        self.temperature = "\(Int(decodedResponse.main.temp))°"
                        self.highTemp = "H: \(Int(decodedResponse.main.tempMax))°"
                        self.lowTemp = "L: \(Int(decodedResponse.main.tempMin))°"
                        
                        self.averageTemp = String(format: "+ %.1f°", (decodedResponse.main.tempMax + decodedResponse.main.tempMin) / 2)
                        
                        if let feelsLike = decodedResponse.main.feelsLike {
                            self.feelsLike = "\(String(format: "%.1f", feelsLike))°"
                        } else {
                            self.feelsLike = "--°"
                        }
                        
                        self.description = decodedResponse.weather.first?.description.capitalized ?? ""
                        
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
                        print("day: \(self.isDaytime)")
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
