//
//  AddTree.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 02/06/25.
//

import ARKit
import AVFoundation
import RealityKit
import SwiftData
import SwiftUI

struct AddTree: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var folders: [TreeFolder]
    
    @State private var newFolderCreated: TreeFolder? = nil
    @State private var showingAddCluster = false
    @State private var selectedFolder: TreeFolder?
    @State private var showingHeightMeasurement = false
    @State private var showingLengthMeasurement = false
    @State private var showingDiameterMeasurement = false
    @State private var showingClinometerMeasurement = false
    @State private var showingCamera = false
    
    @State private var treeName = ""
    @State private var treeSpecie = ""
    @State private var treeExtraNotes = ""
    @State private var treeLatitude: Double = 0.0
    @State private var treeLongitude: Double = 0.0
    
    @State private var height: Double = 0.0
    @State private var length: Double = 0.0
    @State private var diameter: Double = 0.0
    @State private var inclination: Double = 0.0
    
    @Binding var switchToggle: Bool
    @Binding var mapIsSelected: Bool
    
    @StateObject private var locationManager = LocationManager()
    //commentssssss
    let folder: TreeFolder
    
    var body: some View {
        NavigationStack {
            // VTA
            Form {
                // General information
                Section("General information") {
                    TextField("Name", text: $treeName)
                    TextField("Specie", text: $treeSpecie)
                    TextField("Notes", text: $treeExtraNotes, axis: .vertical)
                        .lineLimit(3...6)
                }
                // Location
                // It's slow to update coordinates
                Section("Location") {
                            Toggle("Save tree location", isOn: $switchToggle)
                                .onChange(of: switchToggle) { _, newValue in
                                    if newValue {
                                        locationManager.requestAuthorization()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            if let location = locationManager.location {
                                                treeLatitude = location.coordinate.latitude
                                                treeLongitude = location.coordinate.longitude
                                            } else {
                                                print("⚠️ Nessuna posizione disponibile.")
                                            }
                                        }
                                    }
                                }
                        }
                
            
                Section("Measurements"){
                    
                    HStack{
                        TextField("Tree height", text: Binding(
                            get: {
                                // Show empty if value is 0.0
                                height == 0.0 ? "" : String(height)
                            },
                            set: { newValue in
                                // Try to convert input to Double
                                if let value = Double(newValue) {
                                    height = value
                                } else {
                                    // Optional: Reset or ignore invalid input
                                    height = 0.0
                                }
                            }
                        ))
                        
                        .keyboardType(.decimalPad)
                        Text ("m")
                    }
                        
                    HStack{
                        TextField("Trunk circumference", text: Binding(
                            get: {
                                // Show empty if value is 0.0
                                length == 0.0 ? "" : String(length)
                            },
                            set: { newValue in
                                // Try to convert input to Double
                                if let value = Double(newValue) {
                                    length = value
                                } else {
                                    // Optional: Reset or ignore invalid input
                                    length = 0.0
                                }
                            }
                        ))
                        .keyboardType(.decimalPad)
                        Text ("m")
                    }
                    
                    HStack{
                        TextField("Inclination angle", text: Binding(
                            get: {
                                // Show empty if value is 0.0
                                inclination == 0.0 ? "" : String(inclination)
                            },
                            set: { newValue in
                                // Try to convert input to Double
                                if let value = Double(newValue) {
                                    inclination = value
                                } else {
                                    // Optional: Reset or ignore invalid input
                                    inclination = 0.0
                                }
                            }
                        ))
                        
                        .keyboardType(.decimalPad)
                        Text ("°")
                    }
                    
                    HStack{
                        TextField("Crown projection", text: Binding(
                            get: {
                                // Show empty if value is 0.0
                                diameter == 0.0 ? "" : String(diameter)
                            },
                            set: { newValue in
                                // Try to convert input to Double
                                if let value = Double(newValue) {
                                    diameter = value
                                } else {
                                    // Optional: Reset or ignore invalid input
                                    diameter = 0.0
                                }
                            }
                        ))
                        
                        .keyboardType(.decimalPad)
                        Text ("m²")
                    }
                    
                }
                
                // Camera Measurements
                Section("Camera Measurements") {
                    Button(action: {
                        showingCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(.blue)
                            Text("Open Camera for Measurements")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                
                // Altimeter
                Section("Height Measurement") {
                    Button(action: {
                        showingHeightMeasurement = true
                    }) {
                        HStack {
                            Image(systemName: "ruler")
                                .foregroundColor(.orange)
                            Text("Heigth Measurement")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                
                // Trunk width
                Section("Width Measurement") {
                    Button(action: {
                        showingLengthMeasurement = true
                    }) {
                        HStack {
                            Image(systemName: "ruler")
                                .foregroundColor(.orange)
                            Text("Width Measurement")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                
                Section("Tree Crown Projection Measurement") {
                    Button(action: {
                        showingDiameterMeasurement = true
                    }) {
                        HStack {
                            Image(systemName: "ruler")
                                .foregroundColor(.orange)
                            Text("Diameter Measurement")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                
                //Clinometro - Inclinazione Tronco
                Section("Trunk Inclination Measurement") {
                    Button(action: {
                        showingClinometerMeasurement = true
                    }) {
                        HStack {
                            Image(systemName: "level")
                                .foregroundColor(.purple)
                            Text("Inclination Measurement")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                
                Button("Salva") {
                    saveTree()
                }
            }
            .fullScreenCover(isPresented: $showingCamera) {
                CameraView(
                    onMeasurementTaken: { measurementType, value in
                        handleMeasurement(type: measurementType, value: value)
                    },
                    sourceContext: "AddTree"
                )
            }
            .navigationTitle("Add tree")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTree()
                    }
                    // Disabled if fields are empty
                }
            }
        }
    }
    
    private func handleMeasurement(type: CameraView.MeasurementType, value: Double) {
        switch type {
        case .height:
            height = value
        case .length:
            length = value
        case .diameter:
            diameter = value
        case .inclination:
            inclination = value
        }
    }
    
    private func saveTree() {
        // Create the model Tree
        let newTree = Tree(
            name: treeName,
            specie: treeSpecie,
            extraNotes: treeExtraNotes,
            latitude: treeLatitude,
            longitude: treeLongitude,
            inclination: inclination,
            length: length,
            height: height,
            diameter: diameter
        )
        
        newTree.folder = selectedFolder
        
        modelContext.insert(newTree) // inserting the new tree in the modelcontext
        
        folder.trees.append(newTree) // inserting the new tree in the tree array of the folder
        
        modelContext.insert(folder) // folder updated
        
        do {
            try modelContext.save()
            switchToggle = false  // <-- turn the toggle off
            dismiss()
        } catch {
            print("Errore nel salvataggio: \(error)")
        }
    }
}
