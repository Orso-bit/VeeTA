//
//  FolderView.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 03/06/25.
//

import Foundation
import SwiftData
import SwiftUI

// CONTROLLARE LE VARIABILI CHE SI RIFANNO ALLA CLASSE: NUOVI @STATE O VARIABILI SWIFT DATA?
struct FolderView: View {
    
    @Environment(\.modelContext) private var modelContext
    // @Query private var trees: [TreeFolder] // It allows to access every data of trees but we have to filter based on clusters
    @State private var showingAddTree = false
    @State private var mapIsSelected: Bool = false
    let folder: TreeFolder
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(folder.trees, id: \.self) { tree in
                    NavigationLink {
                        TreeView(tree: tree)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(tree.name).font(.headline)
                            Text(tree.specie).font(.subheadline)
                            /*
                            if !tree.extraNotes.isEmpty {
                                Text(tree.extraNotes).font(.caption)
                            }
                             */
                        }
                    }
                }
                .onDelete(perform: deleteTrees)
            }
            .navigationTitle(folder.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTree = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingAddTree) {
                AddTree(mapIsSelected: $mapIsSelected, folder: folder)
            }
            
        }
    }
    
    private func deleteTrees(at offsets: IndexSet) {
        for index in offsets {
            let tree = folder.trees[index]
            modelContext.delete(tree)
        }
    }
}
/*
 @Environment(\.modelContext) private var modelContext
 
 @State private var showingAddTree = false
 //@Query private var tree : [Tree]
 @Query private var folder: [TreeFolder]
 
 var body: some View {
 NavigationStack {
 List {
 ForEach(folder) { tree in
 NavigationLink{
 TreeView(tree: tree)
 } label:{
 VStack(alignment: .leading, spacing: 4) {
 Text(tree.name)
 .font(.headline)
 .foregroundColor(.primary)
 Text(tree.species)
 .font(.subheadline)
 .foregroundColor(.secondary)
 if !tree.extraNotes.isEmpty {
 Text(tree.extraNotes)
 .font(.caption)
 .foregroundColor(.secondary)
 }
 Text("Creato: \(tree.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))")
 .font(.caption2)
 .foregroundColor(.secondary)
 }
 .padding(.vertical, 2)
 .frame(maxWidth: .infinity, alignment: .leading)
 }
 }
 .onDelete(perform: deleteTrees)
 }
 }
 .sheet(isPresented: $showingAddTree) {
 AddTree(tree: Tree(name: "", species: ""))
 }
 }
 
 func deleteTrees(offsets: IndexSet) {
 withAnimation {
 for index in offsets {
 modelContext.delete(folder.trees[index])
 }
 }
 }
 */
