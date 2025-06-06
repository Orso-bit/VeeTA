//
//  CameraView.swift
//  test
//
//  Created by Vincenzo Salzano on 04/06/25.
//

import SwiftUI
import ARKit
import RealityKit

//CustomARView e CustomArViewRepresentable per settare e mostrare la fotocamera con ArKit
class CustomARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
   dynamic required init?(coder decoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
}
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
                  }
        }

struct CustomArViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return CustomARView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex = 0
    
    // Parametri per gestire il context da cui Ã¨ chiamato
    var onMeasurementTaken: ((MeasurementType, Double) -> Void)?
    var sourceContext: String = "unknown"
    
    enum MeasurementType {
        case height, length, diameter, inclination
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                //TabView con le varie feature da selezionare
                TabView(selection: $selectedIndex) {
                    HeightView(onMeasurementTaken: { height in
                        if let callback = onMeasurementTaken {
                            callback(.height, height)
                        }
                    }).tag(0) //Si apre con questa
                    LengthView().tag(1)
                    ClinometerView().tag(2)
                    ProiectionView().tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(index == selectedIndex ? Color.white : Color.gray)
                            .frame(width: 10, height: 10)
                            .onTapGesture {
                                selectedIndex = index
                            }
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("Measurements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}
