//
//  UIAssets.swift
//  VeeTA
//
//  Created by Alessandro Rippa on 29/05/25.
//

import SwiftUI
import SwiftData

struct MeasurementView: View {

    let tree: Tree
    
    var body: some View {
        
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
         
    }
}
/*
 #Preview { }
 */
