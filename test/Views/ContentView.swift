//
//  ContentView.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 30/05/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var folders: [TreeFolder]
    @Query private var trees: [Tree]
    
    @State private var showingAddCluster = false
    
    var body: some View {
        NavigationStack {
            
            if folders.isEmpty {
                VStack{
                    Spacer()
                    Image(systemName: "tree.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height:45)
                        .padding(12)
                        .foregroundStyle(.background)
                        .background(Circle()
                            .foregroundStyle(.tertiary))
                    Text("""
                         add your first cluster
                         by pressing the + button
                         """)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
            }
            
            List {
                ForEach(folders, id:\.self) { folder in
                    NavigationLink {
                        FolderView(folder: folder)
                    } label: {
                        VStack {
                            Text(folder.name)
                        }
                    }
                }
                .onDelete(perform: deleteFolder)
            }
            .navigationTitle("Clusters")
            .searchable(text: .constant(""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCluster = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                // OK MA BISOGNA CREARE SOLO IL CLUSTER E UNA VOLTA LI' GLI ALBERI
            }
            // Add Cluster View
            .fullScreenCover(isPresented: $showingAddCluster) {
                AddCluster()
            }
        }
    }
    
    // func to delete
    func deleteFolder(_ indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                let folderToDelete = folders[index]
                modelContext.delete(folderToDelete)
            }
            do {
                try modelContext.save()
            } catch {
                print("Errore durante l'eliminazione del folder: \(error)")
            }
        }
    }
}

// add func to delete and edit folder

/*NavigationStack {
 VStack {
 // View without folders
 if folders.isEmpty {
 Text("No folders yet")
 }
 // View with folders
 if !folders.isEmpty {
 List {
 ForEach(folders) { folder in
 NavigationLink(destination: FolderView(folder: folder)) {
 Text(folder.name)
 }
 }
 .onDelete(perform: deleteFolders)
 }
 }
 }
 .padding()
 .navigationBarTitle("Clusters")
 .toolbar {
 ToolbarItem(placement: .navigationBarTrailing) {
 Button(action: {
 showingAddOptions = true
 }) {
 Image(systemName: "plus")
 }
 }
 }.confirmationDialog("Add", isPresented: $showingAddOptions) {
 Button("New Tree") {
 showingAddTree = true
 }
 Button("New Cluster") {
 showingAddCluster = true
 }
 Button("Cancel", role: .cancel) { }
 }
 
 // Add Cluster View
 .sheet(isPresented: $showingAddCluster) {
 AddCluster(newFolderCreated: $newFolderCreated)
 }
 
 // Add Tree View
 .sheet(isPresented: $showingAddTree) {
 AddTree()
 }
 }
 }
 
 private func deleteFolders(offsets: IndexSet) {
 withAnimation {
 for index in offsets {
 modelContext.delete(folders[index])
 }
 }
 */

#Preview {
    ContentView()
}
