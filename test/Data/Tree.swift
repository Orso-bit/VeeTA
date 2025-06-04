//
//  Tree.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 02/06/25.
//

import Foundation
import SwiftData

@Model
class Tree: Identifiable {
    
    // Relation with folders
    @Relationship(inverse: \TreeFolder.trees)
    var folder: TreeFolder?
    
    var name: String
    var specie: String
    var extraNotes: String
    var createdAt: Date
    var lastModified: Date
    
    var latitude: Double
    var longitude: Double
    
    // clinometer
    var inclination: Double
    var inclinationDate: Date
    
    // length
    var length: Double
    var lengthMeasurementDate: Date
    
    // height
    var height: Double
    var measurementDate: Date
    
    // tree projection
    var diameter: Double
    var diameterDate: Date
    
    
    //PAST MEASUREMENTS
    var pastLenghts: [Double] = []
    var pastLenghtsDate: [Date] = []
    
    var pastHeights: [Double] = []
    var pastHeightsDate: [Date] = []
    
    var pastDiameters: [Double] = []
    var pastDiametersDate: [Date] = []
    
    var pastInclinations: [Double] = []
    var pastInclinationsDate: [Date] = []
    
    
    //i wrap del mc donald
    var wrappedLength: String {
        return String(format: "%.2f", length)
    }
    var wrappedHeight: String {
        return String(format: "%.2f", height)
    }
    var wrappedDiameter: String {
        return String(format: "%.2f", diameter)
    }
    var wrappedInclination: String {
        return String(format: "%.2f", inclination)
    }
    
    init(
        name: String,
        specie: String,
        extraNotes: String? = nil,
        
        latitude: Double? = nil,
        longitude: Double? = nil,
        
        inclination: Double? = nil,
        
        length: Double? = nil,
        
        height: Double? = nil,
        
        diameter: Double? = nil
    ) {
        self.name = name
        self.specie = specie
        self.extraNotes = extraNotes ?? ""
        self.createdAt = Date.now
        self.lastModified = Date.now
        
        self.latitude = latitude ?? 00.0
        self.longitude = longitude ?? 00.0
        
        self.inclination = inclination ?? 00.0
        self.inclinationDate = Date.now
        
        self.length = length ?? 00.0
        self.lengthMeasurementDate = Date.now
        
        self.height = height ?? 00.0
        self.measurementDate = Date.now
        
        self.diameter = diameter ?? 00.0
        self.diameterDate = Date.now
    }
}
