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
        
        // Instead of checking immediately, request authorization first
        locationManager.requestWhenInUseAuthorization()
    }

    // Add this delegate method to handle the location services enabled status
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let clError = error as? CLError, clError.code == .denied {
                self.hasError = true
                self.errorMessage = "Location services are disabled. Please enable them in Settings."
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Move the status check to a background queue
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let isEnabled = CLLocationManager.locationServicesEnabled()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.locationStatus = manager.authorizationStatus
                
                if !isEnabled {
                    self.hasError = true
                    self.errorMessage = "Location services are disabled. Please enable them in Settings."
                    return
                }
                
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
    }
    
    deinit {
        monitor.cancel()
    }
}
