//
//  CustomTabBar.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-17.
//

import SwiftUI

struct CustomTabBar: View {
    init() {
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
        }
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("", systemImage: "map")
                }

            SearchScreen()
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
