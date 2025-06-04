//
//  MapView.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 04/06/25.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var isAuthorized = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

struct MapView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    let tree: Tree?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear {
                    locationManager.requestAuthorization()
                    if let location = locationManager.location {
                        region.center = location.coordinate
                    }
                }
            
            Button(action: {
                if let location = locationManager.location {
                    withAnimation {
                        region.center = location.coordinate
                    }
                }
            }) {
                Image(systemName: "location.fill")
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding()
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer(
        for: TreeFolder.self, Tree.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    return MapView(tree: nil)
        .modelContainer(modelContainer)
}

