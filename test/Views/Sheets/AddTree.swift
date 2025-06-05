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
    
    @State private var treeName = ""
    @State private var treeSpecie = ""
    @State private var treeExtraNotes = ""
    @State private var treeLatitude: Double = 0.0
    @State private var treeLongitude: Double = 0.0
    
    @State private var height: Double = 0.0
    @State private var length: Double = 0.0
    @State private var diameter: Double = 0.0
    @State private var inclination: Double = 0.0
    
    @Binding var mapIsSelected: Bool
    
    @StateObject private var locationManager = LocationManager()
    
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
                    Toggle("Save tree location", isOn: $mapIsSelected)
                        .onChange(of: mapIsSelected) { oldValue, newValue in
                            if newValue {
                                locationManager.requestAuthorization()
                                if let location = locationManager.location {
                                    treeLatitude = location.coordinate.latitude
                                    treeLongitude = location.coordinate.longitude
                                }
                            }
                        }
                }
                
            
                Section("Measurements"){
                    TextField("Tree Height", value: $height, formatter: NumberFormatter())
                    TextField("Trunk circumference", value: $length, formatter: NumberFormatter())
                    TextField("Inclination angle", value: $inclination, formatter: NumberFormatter())
                    TextField("Crown projection", value: $diameter, formatter: NumberFormatter())
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
            .navigationTitle("Aggiungi Albero")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        saveTree()
                    }
                    // Disabled if fields are empty
                }
            }
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
            mapIsSelected = false  // <-- turn the toggle off
            dismiss()
        } catch {
            print("Errore nel salvataggio: \(error)")
        }
    }
}
