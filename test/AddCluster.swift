//
//  AddCluster.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 02/06/25.
//

import SwiftData
import SwiftUI

struct AddCluster: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var folderName: String = ""

    
    var body: some View {
        NavigationStack {
            Form {
                Section("Cluster Information") {
                    TextField("Cluster Name", text: $folderName)
                }
            }
            .navigationTitle("New Cluster")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCluster()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
        }
    }
    // Cluster saving
    private func saveCluster() {
        let newFolder = TreeFolder(name: folderName)
        modelContext.insert(newFolder)
        do {
            try modelContext.save()
            
            dismiss()
        } catch {
            print("Errore nel salvataggio cluster: \(error)")
        }
        
    }
}
