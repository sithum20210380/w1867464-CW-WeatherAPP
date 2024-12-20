//
//  CustomTabBar.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-17.
//

import SwiftUI

struct CustomTabBar: View {
    @StateObject private var viewModel = WeatherViewModel()

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }

    var body: some View {
        TabView {
            ContentView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("", systemImage: "map")
                }

            SearchScreen(viewModel: viewModel)
                .tabItem {
                    Label("", systemImage: "list.bullet")
                }
        }
        .accentColor(.white)
    }
}


#Preview {
    CustomTabBar()
}
