//
//  CustomTabBar.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-17.
//

import SwiftUI

struct CustomTabBar: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var selectedTab: Int = 1
    @State private var currentPage: Int = 0
    
    init() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().barTintColor = .clear
        UITabBar.appearance().unselectedItemTintColor = .black.withAlphaComponent(0.7)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapView(viewModel: viewModel)
                .tabItem { Label("", systemImage: "map") }
                .tag(0)
            
            WeatherPagesView(currentPage: $currentPage, viewModel: viewModel)
                .tabItem {
                    Label {
                        Text("")
                    } icon: {
                        Image(systemName: "location.fill")
                    }
                }
                .tag(1)
            
            SearchScreen(viewModel: viewModel)
                .tabItem { Label("", systemImage: "list.bullet") }
                .tag(2)
        }
        .accentColor(.black)
    }
}

// New WeatherPagesView to handle paging
struct WeatherPagesView: View {
    @Binding var currentPage: Int
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        TabView(selection: $currentPage) {
            ContentView()
                .environmentObject(viewModel)
                .tag(0)
            
            ForEach(viewModel.favoriteCities) { city in
                FavoriteWeatherView(cityName: city.name, viewModel: viewModel)
                    .tag(city.id)
            }
        }
        //.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

#Preview {
    CustomTabBar()
}
