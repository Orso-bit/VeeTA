//
//  ProiectionView.swift
//  test
//
//  Created by Vincenzo Salzano on 04/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ProiectionView: View {
    var body: some View {
        //Mostra la fotocamera con ArKit
        CustomArViewRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    ProiectionView()
}
