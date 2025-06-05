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
    @State private var mapIsSelected: Bool = false
    
    @Bindable var tree: Tree
    
    var body: some View {
        
        NavigationStack{
                
            ScrollView(showsIndicators: false){
                
                //Divider()
                
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
                
                VStack{
                    HStack{
         
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height:100)
                                    .foregroundStyle(.accent)
                                
                                VStack{
                                    Image(systemName: "ruler.fill")
                                        .foregroundStyle(.white)
                                    
                                        VStack{
                                            Text(tree.wrappedHeight + "m")
                                                .lineLimit(1)
                                                .font(.title)
                                                .fontWeight(.regular)
                                                .foregroundColor(Color.white)
                                        }
                                    
                                    
                                    Text("height")
                                        .font(.title3)
                                        .fontWeight(.thin)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                        
                        
                        
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height:100)
                                    .foregroundStyle(.accent)
                                
                                VStack{
                                    Image(systemName: "ruler.fill")
                                        .foregroundStyle(.white)
                                    
                                    VStack{
                                        Text(tree.wrappedLength + "m")
                                            .lineLimit(1)
                                            .font(.title)
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.white)
                                    }
                                    
                                    Text("trunk diameter")
                                        .font(.title3)
                                        .fontWeight(.thin)
                                        .foregroundColor(Color.white)
                                }
                                
                                
                            }
                        
                        
                    }
                    HStack{
                        //if let current
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height:100)
                                .foregroundStyle(.accent)
                            
                            VStack{
                                Image(systemName: "angle")
                                    .foregroundStyle(.white)
                                
                                VStack{
                                    Text(tree.wrappedInclination + "°")
                                        .lineLimit(1)
                                        .font(.title)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.white)
                                }
                                
                                Text("inclination")
                                    .font(.title3)
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.white)
                            }
                    
                            
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height:100)
                                .foregroundStyle(.accent)
                            
                            VStack{
                                Image(systemName: "leaf.fill")
                                    .foregroundStyle(.white)
                                
                                VStack{
                                    Text(tree.wrappedDiameter + "m²")
                                        .lineLimit(1)
                                        .font(.title)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.white)
                                }
                                
                                Text("crown projection")
                                    .font(.title3)
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.white)
                            }
                    
                            
                        }
                    }
                }
                    .padding(.horizontal,10)
                    .padding(.vertical,25)
                
                
                VStack(spacing:5){
                    HStack{
                        Text("Notes")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accent)
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius:20)
                            .fill(Color.gray.opacity(0.3))
                            .frame(minHeight:300)
                            .padding(.horizontal,20)
                        
                        VStack{
                            Text("\(tree.extraNotes)")
                                .frame(alignment: .leading)
                                .padding()
                            /*
                             .background(.gray.opacity(0.3))
                             .clipShape(RoundedRectangle(cornerRadius:30))
                             */
                                .padding(.horizontal,20)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(tree.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        //selectedTreeToEdit = tree
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        mapIsSelected = true
                    } label: {
                        Image(systemName: "map.fill")
                    }
                }
            }
        }
        
        .sheet(isPresented: $mapIsSelected){
            MapView(treeLatitude: $tree.latitude, treeLongitude: $tree.longitude)
        }
    }
}
