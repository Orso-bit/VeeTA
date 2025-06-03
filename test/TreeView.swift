//
//  TreeView.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 03/06/25.
//

import SwiftData
import SwiftUI

struct TreeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var folders: [TreeFolder]
    
    @Bindable var tree: Tree
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                Divider()
                
                VStack(spacing:20){
                    
                    HStack{
                        Text("CLUSTER")
                          
                        Spacer()
                        
                        Text("\(tree.name)")
                            .fontWeight(.light)
                        
                    }.padding(.horizontal,25)
                    
                    HStack{
                        Text("SPECIES")
                          
                        Spacer()
                        
                        Text("\(tree.specie)")
                            .fontWeight(.light)
                        
                    }.padding(.horizontal,25)
                    
                    HStack{
                        Text("ADDED")
                          
                        Spacer()
                        
                        Text(tree.createdAt.formatted())
                            .fontWeight(.light)
                        
                    }.padding(.horizontal,25)
                    
                    HStack{
                        Text("LAST MODIFIED")
                          
                        Spacer()
                        
                        Text(tree.createdAt.formatted())
                            .fontWeight(.light)
                        //DA MODIFICARE!!! AL MOMENTO NON ESISTE LAST MODIFIED COME PARAMETRO
                        
                    }.padding(.horizontal,25)
                    

                }
                .padding(.vertical,25)
            }
        }
    }
}
