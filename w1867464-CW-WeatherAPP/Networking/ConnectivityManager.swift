//
//  ConnectivityManager.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2025-01-05.
//

import Network
import CoreLocation
import SwiftUI

class ConnectivityManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isConnected = false
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLocationServicesEnabled = false
    @Published var hasError = false
    @Published var errorMessage = ""
    
    private let monitor = NWPathMonitor()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupNetworkMonitoring()
        setupLocationServices()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                if !self!.isConnected {
                    self?.hasError = true
                    self?.errorMessage = "No internet connection. Please check your connection and try again."
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    private func setupLocationServices() {
        locationManager.delegate = self
        isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
        
        if !isLocationServicesEnabled {
            DispatchQueue.main.async { [weak self] in
                self?.hasError = true
                self?.errorMessage = "Location services are disabled. Please enable them in Settings."
            }
            return
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.locationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .denied, .restricted:
                self.hasError = true
                self.errorMessage = "Location access denied. Please enable location services for this app in Settings."
            case .authorizedWhenInUse, .authorizedAlways:
                self.hasError = false
                self.errorMessage = ""
                self.locationManager.startUpdatingLocation()
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            @unknown default:
                break
            }
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
