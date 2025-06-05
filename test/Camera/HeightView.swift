//
//  HeightView.swift
//  test
//
//  Created by Vincenzo Salzano on 04/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct HeightView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        //Mostra la fotocamera con ArKit
        CustomArViewRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    HeightView()
}
