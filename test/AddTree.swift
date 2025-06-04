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
    
    let folder: TreeFolder
    
    var body: some View {
        NavigationStack {
            // VTA
            Form {
                // General information
                Section("Informazioni Albero") {
                    TextField("Nome albero", text: $treeName)
                    TextField("Specie", text: $treeSpecie)
                    TextField("Note extra", text: $treeExtraNotes, axis: .vertical)
                        .lineLimit(3...6)
                }
                /*
                // Cluster inserting
                Section("Cluster") {
                    if folders.isEmpty {
                        Button("Create a new cluster") {
                            showingAddCluster = true
                        }
                    } else {
                        Picker("Cluster Selection", selection: $selectedFolder) {
                            Text("No Cluster").tag(nil as TreeFolder?)
                            ForEach(folders, id: \.self) { folder in
                                Text(folder.name).tag(folder as TreeFolder?)
                            }
                        }
                        
                        Button("Create new cluster") {
                            showingAddCluster = true
                        }
                    }
                }*/
                
                // Location
                
                // Altimeter
                Section("Heigth Measurement") {
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
            latitude: 0.0,
            longitude: 0.0,
            inclination: 0.0,
            length: 0.0,
            height: 0.0,
            diameter: 0.0
        )
        
        newTree.folder = selectedFolder
        
        modelContext.insert(newTree) // inserting the new tree in the modelcontext
        
        folder.trees.append(newTree) // inserting the new tree in the tree array of the folder
        
        modelContext.insert(folder) // folder updated
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Errore nel salvataggio: \(error)")
        }
    }
}
