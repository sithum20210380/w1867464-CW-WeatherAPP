//
//  CustomTabBar.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-17.
//

import SwiftUI

enum TabItem: Int {
    case map = 0
    case weather = 1
    case favorites = 2
    case search = 3
    
    var icon: String {
        switch self {
        case .map: return "map"
        case .weather: return "location.fill"
        case .favorites: return "star.fill"
        case .search: return "list.bullet"
        }
    }
    
    var label: String {
        switch self {
        case .map: return "Map"
        case .weather: return "Weather"
        case .favorites: return "Favorites"
        case .search: return "Search"
        }
    }
}

// CustomPageIndicator component
struct CustomPageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                    .animation(.spring(), value: currentPage)
            }
        }
        .padding(.vertical, 8)
    }
}

// FavoritesView component
struct FavoritesView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var currentPage: Int = 0
    @State private var cityWeatherViewModels: [WeatherViewModel] = []
    
    var body: some View {
        ZStack {
            if viewModel.favoriteCities.isEmpty {
                Text("No favorite cities added")
                    .foregroundColor(.gray)
            } else {
                TabView(selection: $currentPage) {
                    ForEach(viewModel.favoriteCities.indices, id: \.self) { index in
                        if cityWeatherViewModels.indices.contains(index) {
                            FavoriteWeatherView()
                                .environmentObject(cityWeatherViewModels[index])
                                .onAppear {
                                    Task {
                                        await cityWeatherViewModels[index]
                                            .getCoordinatesForCity(viewModel.favoriteCities[index].name)
                                    }
                                }
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .animation(.easeInOut, value: currentPage)
                
                if viewModel.favoriteCities.count > 1 {
                    CustomPageIndicator(
                        numberOfPages: viewModel.favoriteCities.count,
                        currentPage: currentPage
                    )
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
                }
            }
        }
        .onAppear {
            setupCityWeatherViewModels()
        }
        .onChange(of: viewModel.favoriteCities) {
            print("Favorite cities: \(viewModel.favoriteCities)")
            print("CityWeatherViewModels: \(cityWeatherViewModels.map { $0.cityName })")
            setupCityWeatherViewModels()
            currentPage = max(0, min(currentPage, viewModel.favoriteCities.count - 1))
        }
    }
    
    private func setupCityWeatherViewModels() {
        let updatedViewModels = viewModel.favoriteCities.map { city in
            let cityViewModel = WeatherViewModel()
            cityViewModel.cityName = city.name
            Task {
                await cityViewModel.getCoordinatesForCity(city.name)
            }
            return cityViewModel
        }
        cityWeatherViewModels = updatedViewModels
    }
}

// CustomTabBar component
struct CustomTabBar: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var selectedTab: TabItem = .weather
    @State private var previousTab: TabItem = .weather
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil
        appearance.stackedLayoutAppearance.normal.iconColor = .white.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapView(viewModel: viewModel)
                .tabItem {
                    Label(TabItem.map.label, systemImage: TabItem.map.icon)
                }
                .tag(TabItem.map)
            
            ContentView()
                .environmentObject(viewModel)
                .tabItem {
                    Label(TabItem.weather.label, systemImage: TabItem.weather.icon)
                }
                .tag(TabItem.weather)
            
            FavoritesView(viewModel: viewModel)
                .environmentObject(viewModel)
                .tabItem {
                    Label(TabItem.favorites.label, systemImage: TabItem.favorites.icon)
                }
                .tag(TabItem.favorites)
            
            SearchScreen(viewModel: viewModel)
                .tabItem {
                    Label(TabItem.search.label, systemImage: TabItem.search.icon)
                }
                .tag(TabItem.search)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .accentColor(.white)
    }
}

#Preview {
    CustomTabBar()
}
