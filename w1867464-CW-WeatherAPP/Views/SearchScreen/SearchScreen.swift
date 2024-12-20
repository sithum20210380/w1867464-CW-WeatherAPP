//
//  SwiftUIView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-17.
//

import SwiftUI

struct SearchScreen: View {
    @State private var searchQuery: String = ""
    @ObservedObject var viewModel: WeatherViewModel
    @State private var searchResults: [String] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Search City")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
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
                
                // Search Results
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(searchResults, id: \.self) { city in
                            Button(action: {
                                selectCity(city)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(city)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text("Mostly Cloudy")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("84°")
                                            .font(.title)
                                            .foregroundColor(.white)
                                        
                                        Text("H:88° L:75°")
                                            .font(.footnote)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.edgesIgnoringSafeArea(.all))
        }
    }
    
    private func performSearch() {
        if !searchQuery.isEmpty {
            searchResults = ["\(searchQuery)"]
        } else {
            searchResults = []
        }
    }
    
    private func selectCity(_ city: String) {
        viewModel.fetchWeather(for: city)
        dismiss()
    }
}

#Preview {
    SearchScreen(viewModel: WeatherViewModel())
}
