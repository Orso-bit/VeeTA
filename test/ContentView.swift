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
    
    @State private var showingAddOptions = false
    @State private var showingAddTree = false
    @State private var showingAddCluster = false
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                
                if folders.isEmpty {
                    VStack{
                        Text("Create your first cluster")
                        Image(systemName: "tree")
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                showingAddOptions = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                
                else{
                    
                    ForEach(folders, id:\.self) { folder in
                        NavigationLink {
                            FolderView(folder: folder)
                        } label: {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height: 90)
                                    .foregroundStyle(Color.accentColor)
                                HStack{
                                    VStack{
                                        Text(folder.name)
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack{
                                        Spacer()
                                        HStack{
                                            Image(systemName: "tree.fill")
                                                .foregroundStyle(.white)
                                            Text("\(folder.trees.count)")
                                                .font(.title)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.white)
                                        }
                                        
                                    }
                                }
                                .padding()
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                showingAddOptions = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddOptions) {
                AddCluster()
            }
            .navigationTitle("Clusters")
            .searchable(text: .constant(""))
        }
        
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
    }
}

#Preview {
    ContentView()
}
