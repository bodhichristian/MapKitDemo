//
//  BeanTownButtons.swift
//  MapKitDemo
//
//  Created by christian on 6/22/23.
//

import SwiftUI
import MapKit

struct BeanTownButtons: View {
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]
    
    var visibleRegion: MKCoordinateRegion?
    
    let width = 25.0
    
    var body: some View {
        HStack {
            Button{
                withAnimation {
                    search(for: "playground")
                }
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
                    .frame(width: width, height: width)

            }
            .buttonStyle(.borderedProminent)
            
            Button {
                withAnimation {
                    search(for: "beach")
                }
            } label: {
                Label("Beaches", systemImage: "beach.umbrella")
                    .frame(width: width, height: width)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                withAnimation {
                    position = .region(.boston)
                }
            } label: {
                Label("Boston", systemImage: "building.2")
                    .frame(width: width, height: width)
            }
            .buttonStyle(.borderedProminent)

            Button {
                withAnimation {
                    position = .region(.northShore)
                }
            } label: {
                Label("North Shore", systemImage: "water.waves")
                    .frame(width: width, height: width)
            }
            .buttonStyle(.borderedProminent)

            Button {
                withAnimation {
                    position = .item(.mapItem)
                }
            } label: {
                Label("Map Item", systemImage: "map")
                    .frame(width: width, height: width)
            }
            .buttonStyle(.borderedProminent)

            
            Button {
                withAnimation{
                    position = .camera(
                        MapCamera(
                            centerCoordinate: CLLocationCoordinate2D(
                                latitude: 42.360431,
                                longitude: -71.055930),
                            distance: 980,
                            heading: 242,
                            pitch: 60
                        )
                    )
                }
            } label: {
                Label("Secret Location", systemImage: "angle")
                    .frame(width: width, height: width)
            }
            .buttonStyle(.borderedProminent)
        }
        .labelStyle(.iconOnly)
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .parking,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}
