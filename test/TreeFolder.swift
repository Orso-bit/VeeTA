//
//  TreeFolder.swift
//  test
//
//  Created by Giovanni Jr Di Fenza on 02/06/25.
//

import Foundation
import SwiftData

@Model
class TreeFolder {
    var name: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var trees: [Tree]
    
    init(name: String, createdAt: Date = .now, trees: [Tree] = []) {
        self.name = name
        self.createdAt = createdAt
        self.trees = trees
    }
}
