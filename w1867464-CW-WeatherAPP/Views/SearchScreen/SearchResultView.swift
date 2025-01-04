//
//  SearchResultView.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2025-01-02.
//

import SwiftUI

struct SearchResultView: View {
    let city: String
    @ObservedObject var viewModel: WeatherViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ContentView()
                .environmentObject(viewModel)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(){
                        dismiss()
                    }label: {
                        Text("Cancel")
                    }
                    .tint(.white)
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button(){
                        dismiss()
                        viewModel.addToFavorites(city)
                    }label: {
                        Text("Add")
                    }
                    .tint(.white)
                }
            }
        }
    }
}

#Preview {
    SearchResultView(city: "Colombo", viewModel: WeatherViewModel())
}
