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
    // var changed in TreeView
    @Binding var treeLatitude: Double
    @Binding var treeLongitude: Double
    
    @State private var region: MKCoordinateRegion
    
    @StateObject private var locationManager = LocationManager()
    
    init(treeLatitude: Binding<Double>, treeLongitude: Binding<Double>) {
        self._treeLatitude = treeLatitude
        self._treeLongitude = treeLongitude
        
        let initialCoordinate = CLLocationCoordinate2D(latitude: treeLatitude.wrappedValue, longitude: treeLongitude.wrappedValue)
        
        _region = State(initialValue: MKCoordinateRegion(
            center: initialCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
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
                // latitudes updated
                .onChange(of: region.center.latitude) { oldLatitude, newLatitude in
                    treeLatitude = newLatitude
                }
                // longitudes updated
                .onChange(of: region.center.longitude) { oldLongitude, newLongitude in
                    treeLongitude = newLongitude
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
