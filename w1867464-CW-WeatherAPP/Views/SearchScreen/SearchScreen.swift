//
//  SwiftUIView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-17.
//

import SwiftUI
import CoreLocation

struct SearchScreen: View {
    @State private var searchQuery: String = ""
    @ObservedObject var viewModel: WeatherViewModel
    @State private var searchResults: [CitySearchResult] = []
    @State private var selectedCity: CitySearchResult?
    @State private var showResult = false
    @State private var selectedFavoriteCity: FavoriteCity?
    @State private var showFavoritePreview = false
    @Environment(\.dismiss) private var dismiss
    
    struct CitySearchResult: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let lat: Double
        let lon: Double
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: CitySearchResult, rhs: CitySearchResult) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Search City")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        
                        TextField("Search for a city or airport", text: $searchQuery)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: searchQuery) { _ in
                                performSearch()
                            }
                    }
                    .background(Color(.systemGray5).opacity(0.2))
                    .cornerRadius(8)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if !searchResults.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Search Results")
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    
                                    ForEach(searchResults) { city in
                                        Button(action: {
                                            selectedCity = city
                                            Task {
                                                await viewModel.fetchWeather(latitude: city.lat, longitude: city.lon)
                                                viewModel.cityName = city.name
                                                showResult = true
                                            }
                                        }) {
                                            HStack {
                                                Text(city.name)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Button(action: {
                                                    viewModel.addToFavorites(city.name)
                                                }) {
                                                    Image(systemName: "star")
                                                        .foregroundColor(.yellow)
                                                }
                                            }
                                            .padding()
                                            .background(Color(.systemGray6).opacity(0.3))
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            if !viewModel.favoriteCities.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Favorites")
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    
                                    ForEach(viewModel.favoriteCities) { city in
                                        FavoriteWeatherCard(city: city, viewModel: viewModel)
                                            .onTapGesture {
                                                selectedFavoriteCity = city
                                                Task {
                                                    await viewModel.fetchWeather(latitude: city.latitude, longitude: city.longitude)
                                                    viewModel.cityName = city.name
                                                    showFavoritePreview = true
                                                }
                                            }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showResult) {
            if let city = selectedCity {
                SearchResultView(city: city.name, viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showFavoritePreview) {
            if let city = selectedFavoriteCity {
                SearchResultView(city: city.name, viewModel: viewModel)
            }
        }
    }
    
    private func performSearch() {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        
        // Use the geocoding API to get coordinates
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchQuery) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                searchResults = placemarks?.compactMap { placemark in
                    guard let name = placemark.locality ?? placemark.name,
                          let location = placemark.location else {
                        return nil
                    }
                    
                    return CitySearchResult(
                        name: name,
                        lat: location.coordinate.latitude,
                        lon: location.coordinate.longitude
                    )
                } ?? []
            }
        }
    }
}

struct SearchResultRow: View {
    let city: SearchScreen.CitySearchResult
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        HStack {
            Text(city.name)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Button(action: {
                viewModel.addToFavorites(city.name)
            }) {
                Image(systemName: "star")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
}

// Favorite Weather Card Component
struct FavoriteWeatherCard: View {
    let city: FavoriteCity
    @ObservedObject var viewModel: WeatherViewModel
    @State private var temperature: String = "--°"
    @State private var highTemp: String = "H:--°"
    @State private var lowTemp: String = "L:--°"
    @State private var description: String = "Loading..."
    @State private var currentTime: String = "--:--"
    @State private var isDaytime: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                VStack{
                    HStack {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.title2)
                                .bold()
                            Text(currentTime)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(temperature)
                            .font(.system(size: 40))
                            .bold()
                    }
                    
                    HStack {
                        Text(description)
                        Spacer()
                        Text("\(highTemp) \(lowTemp)")
                    }
                    .font(.subheadline)
                }
                Button(action: {
                    viewModel.removeFromFavorites(city.name)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                }
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(viewModel.isDaytime ? Color(.systemBlue).opacity(0.3) : Color(.black).opacity(0.5))
        .cornerRadius(15)
        .onAppear {
            fetchWeatherForCard()
            startTimeUpdates()
        }
    }
    
    private func fetchWeatherForCard() {
        let urlString = "\(APIConfig.oneCallBaseURL)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(APIConfig.oneCallAPIKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.temperature = "\(Int(response.current.temp))°"
                    if let today = response.daily.first {
                        self.highTemp = "H:\(Int(today.temp.max))°"
                        self.lowTemp = "L:\(Int(today.temp.min))°"
                    }
                    self.description = response.current.weather.first?.description.capitalized ?? ""
                }
            } catch {
                print("Error fetching weather for card: \(error)")
            }
        }.resume()
    }
    
    private func startTimeUpdates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.currentTime = formatter.string(from: Date())
        
        // Update time every minute
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.currentTime = formatter.string(from: Date())
        }
    }
}

#Preview {
    SearchScreen(viewModel: WeatherViewModel())
}
