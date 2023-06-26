//
//  ContentView.swift
//  MapKitDemo
//
//  Created by christian on 6/22/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    // MARK: Route Style Params for MapPolyline
    let gradient = LinearGradient(
        colors: [.red, .green, .blue],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    let stroke = StrokeStyle(
        lineWidth: 5,
        lineCap: .round, lineJoin: .round, dash: [10, 10]
    )
    
    var body: some View {
        Map(position: $position, selection: $selectedResult) {
            // MARK: Marker
            // Default marker - system balloon
            Marker("Meeting Spot", coordinate: .meetingSpot)
            
            // Custom marker - system image
            Marker("Ducklings", systemImage: "bird.fill", coordinate: .ducklings)
                .tint(.mint)
            
            // Custom marker - image asset
            Marker("The Spot", image: "imageAsset", coordinate: .theSpot)
                .tint(.blue)
            
            // Custom marker - monogram
            Marker("Monogram", monogram: "(CL)", coordinate: .secretLair)
                .tint(.orange)
            
            // MARK: Annotation
            // Annotation allows presentation of custom views
            // Content will center on coordinate unless anchor is provided
            Annotation("Parking", coordinate: .parking, anchor: .bottom) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "car")
                        .padding(5)
                }
            }
            .annotationTitles(.hidden) // Hides annotation label
            
            // Render a marker for each search result
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
                    .annotationTitles(.hidden)
            }
            
            UserAnnotation()
            
            // MARK: MapPolyline
            // Use MapPolyline to draw the route
            if let route {
                MapPolyline(route)
                    .stroke(gradient, style: stroke)
            }
        }
        .onAppear {
            locationManager.checkIfLocationServicesIsEnabled()
        }
        
        // MARK: mapStyle
        // .standard renders default map view
        // .imagery renders sattelite view
        // .hybrid renders sattelite view with road and POI labels
        .mapStyle(.hybrid(elevation: .realistic, pointsOfInterest: .all))
        
        // MARK: safeAreaInset
        // Ensures app's UI doesn't obscure any added content or system provided controls--i.e. Apple Maps logo, Legal link
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing: 0){
                    if let selectedResult {
                        ItemInfoView(selectedResult: selectedResult, route: route)
                            .frame(height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                    BeanTownButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                        .padding(.top)
                }
                Spacer()
            }
            .background(.thinMaterial)
        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onChange(of: selectedResult) {
            getDirections()
        }
        
        // MARK: onMapCameraChange
        // Assigns the current map view to the visibleRegion
        // Called when user is done interacting with the map
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        
        // MARK: mapControls
        // Content will be placed in default positions
        .mapControls {
            // Tap to center map on user's location
            MapUserLocationButton()
            // Appears when map has been rotated by user
            MapCompass()
            // Appears while user is zooming in or out
            MapScaleView()
        }
    }
    
    // MARK: getDirections()
    // Calculates a route from user location to selectedResult
    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        guard let currentLocation = locationManager.manager?.location?.coordinate else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    ContentView()
}


