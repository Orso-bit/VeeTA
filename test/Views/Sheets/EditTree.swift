//
//  EditTree.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 05/06/25.
//

import SwiftUI
import SwiftData

struct EditTree: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var folders: [TreeFolder]
    
    @Bindable var tree: Tree
    
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
    
    @Binding var sheetIsOpen: Bool
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            Form {
                // General information
                Section("General information") {
                    TextField("Name", text: $treeName)
                    TextField("Specie", text: $treeSpecie)
                    TextField("Notes", text: $treeExtraNotes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                // Location
                Section("Location") {
                    Toggle("Save tree location", isOn: $sheetIsOpen)
                        .onChange(of: sheetIsOpen) { oldValue, newValue in
                            if newValue {
                                locationManager.requestAuthorization()
                                if let location = locationManager.location {
                                    treeLatitude = location.coordinate.latitude
                                    treeLongitude = location.coordinate.longitude
                                }
                            }
                        }
                }
            
                Section("Measurements") {
                    
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
            }
            .fullScreenCover(isPresented: $showingCamera) {
                CameraView(
                    onMeasurementTaken: { measurementType, value in
                        handleMeasurement(type: measurementType, value: value)
                    },
                    sourceContext: "EditTree"
                )
            }
            .navigationTitle("Edit Tree")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .onAppear {
                loadTreeData()
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
    
    private func loadTreeData() {
        // Carica i dati esistenti del tree negli stati locali
        treeName = tree.name
        treeSpecie = tree.specie
        treeExtraNotes = tree.extraNotes
        treeLatitude = tree.latitude
        treeLongitude = tree.longitude
        height = tree.height
        length = tree.length
        diameter = tree.diameter
        inclination = tree.inclination
        
        // Imposta mapIsSelected se ci sono coordinate valide
        sheetIsOpen = tree.latitude != 0.0 || tree.longitude != 0.0
    }
    
    private func saveChanges() {
        // Aggiorna il tree con i nuovi valori
        tree.name = treeName
        tree.specie = treeSpecie
        tree.extraNotes = treeExtraNotes
        tree.latitude = treeLatitude
        tree.longitude = treeLongitude
        
        // Salva le misurazioni precedenti se sono cambiate
        if tree.height != height {
            tree.height = height
            tree.measurementDate = Date.now
            tree.pastHeights.append(tree.height)
            tree.pastHeightsDate.append(tree.measurementDate)
        }
        
        if tree.length != length {
            tree.length = length
            tree.lengthMeasurementDate = Date.now
            tree.pastLenghts.append(tree.length)
            tree.pastLenghtsDate.append(tree.lengthMeasurementDate)
        }
        
        if tree.diameter != diameter {
            tree.diameter = diameter
            tree.diameterDate = Date.now
            tree.pastDiameters.append(tree.diameter)
            tree.pastDiametersDate.append(tree.diameterDate)
        }
        
        if tree.inclination != inclination {
            tree.inclination = inclination
            tree.inclinationDate = Date.now
            tree.pastInclinations.append(tree.inclination)
            tree.pastInclinationsDate.append(tree.inclinationDate)
        }
        
        // Aggiorna la data di ultima modifica
        tree.lastModified = Date.now
        
        do {
            try modelContext.save()
            sheetIsOpen = false
            dismiss()
        } catch {
            print("Errore nel salvataggio delle modifiche: \(error)")
        }
    }
}
