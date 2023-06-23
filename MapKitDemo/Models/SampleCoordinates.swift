//
//  SampleCoordinates.swift
//  MapKitDemo
//
//  Created by christian on 6/22/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    static let parking = CLLocationCoordinate2D(
        latitude: 42.354528,
        longitude: -71.068369)
    
    static let meetingSpot = CLLocationCoordinate2D(
        latitude: 42.356600,
        longitude: -71.068369)
    
    static let ducklings = CLLocationCoordinate2D(
        latitude: 42.356200,
        longitude: -71.061000)
    
    static let theSpot = CLLocationCoordinate2D(
        latitude: 42.354500,
        longitude: -71.058000)
    
    static let secretLair = CLLocationCoordinate2D(
        latitude: 42.352200,
        longitude: -71.068369)
}

extension MKCoordinateRegion {
    static let boston = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 42.360256,
            longitude: -71.057279),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1)
    )
    
    static let northShore = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 42.547408,
            longitude: -70.870085),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5)
    )
}

extension MKMapItem {
    static let mapItem = MKMapItem(
        placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2D(
                latitude: 42.360431,
                longitude: -71.055930)
        )
    )
}
