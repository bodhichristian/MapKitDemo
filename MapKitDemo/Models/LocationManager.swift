//
//  LocationService.swift
//  MapKitDemo
//
//  Created by christian on 6/23/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var manager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager?.delegate = self
            manager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Location Services Disabled")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let manager = manager else { return }
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Services restriced.")
        case .denied:
            print("This app has been denied Location Services.")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
