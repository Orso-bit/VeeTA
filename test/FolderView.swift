//
//  FolderView.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 03/06/25.
//

import Foundation
import SwiftData
import SwiftUI

struct FolderView: View {
    
    var folder : TreeFolder
    var body: some View {
        Text("FolderView")
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
}
