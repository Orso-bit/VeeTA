//
//  HeightView.swift
//  test
//
//  Created by Vincenzo Salzano on 04/06/25.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

// ARView personalizzata che implementa la misurazione reale
class HeightMeasurementARView: ARView {
    var startPoint: simd_float3?
    var endPoint: simd_float3?
    var measurementNode: ModelEntity?
    var anchorEntity: AnchorEntity?
    var cancellables = Set<AnyCancellable>()
    var currentHeight: Double = 0.0
    var onHeightUpdate: ((Double) -> Void)?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupAR()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAR() {
        // Configurazione della sessione AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        // Esegui la sessione
        session.run(configuration)
        
        // Crea un'entità di ancoraggio per la scena
        anchorEntity = AnchorEntity(world: .zero)
        scene.addAnchor(anchorEntity!)
        
        // Aggiungi il gestore dei tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        
        // Esegui un raycast per trovare la posizione 3D del tap
        let results = raycast(from: location, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = results.first {
            let worldPosition = simd_float3(firstResult.worldTransform.columns.3.x,
                                           firstResult.worldTransform.columns.3.y,
                                           firstResult.worldTransform.columns.3.z)
            
            if startPoint == nil {
                // Primo tap - imposta il punto iniziale
                startPoint = worldPosition
                placeMarker(at: worldPosition, color: .green)
            } else if endPoint == nil {
                // Secondo tap - imposta il punto finale e misura
                endPoint = worldPosition
                placeMarker(at: worldPosition, color: .red)
                drawMeasurementLine()
                calculateHeight()
            } else {
                // Reset e ricomincia
                resetMeasurement()
                startPoint = worldPosition
                placeMarker(at: worldPosition, color: .green)
            }
        }
    }
    
    private func placeMarker(at position: simd_float3, color: UIColor) {
        // Crea un marker visibile
        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.02),
                               materials: [SimpleMaterial(color: color, isMetallic: false)])
        
        // Posiziona il marker
        sphere.position = position
        anchorEntity?.addChild(sphere)
    }
    
    private func drawMeasurementLine() {
        guard let start = startPoint, let end = endPoint else { return }
        
        // Calcola la distanza e crea una linea tra i due punti
        let distance = simd_distance(start, end)
        
        // Crea un'entità linea
        let lineEntity = createLineEntity(from: start, to: end, color: .white)
        anchorEntity?.addChild(lineEntity)
        
        // Aggiungi un'etichetta con la misurazione
        addMeasurementLabel(at: simd_float3((start.x + end.x) / 2,
                                          (start.y + end.y) / 2,
                                          (start.z + end.z) / 2),
                          measurement: distance)
    }
    
    private func createLineEntity(from start: simd_float3, to end: simd_float3, color: UIColor) -> ModelEntity {
        // Calcola la direzione e la lunghezza della linea
        let direction = simd_normalize(end - start)
        let distance = simd_distance(start, end)
        
        // Crea un cilindro sottile come linea
        let mesh = MeshResource.generateBox(size: [0.005, 0.005, Float(distance)])
        let material = SimpleMaterial(color: color, isMetallic: false)
        let lineEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Posiziona e orienta la linea
        lineEntity.position = simd_float3((start.x + end.x) / 2, (start.y + end.y) / 2, (start.z + end.z) / 2)
        
        // Calcola la rotazione necessaria per allineare la linea
        let defaultDirection = simd_float3(0, 0, 1) // Direzione predefinita del cilindro
        let rotationAxis = simd_cross(defaultDirection, direction)
        let rotationAngle = acos(simd_dot(defaultDirection, direction))
        
        if rotationAngle > 0.001 { // Evita rotazioni con angoli molto piccoli
            let rotation = simd_quatf(angle: rotationAngle, axis: simd_normalize(rotationAxis))
            lineEntity.orientation = rotation
        }
        
        return lineEntity
    }
    
    private func addMeasurementLabel(at position: simd_float3, measurement: Float) {
        // Converti la misurazione in metri
        let measurementInMeters = Double(measurement)
        currentHeight = measurementInMeters
        
        // Notifica l'aggiornamento dell'altezza
        onHeightUpdate?(measurementInMeters)
        
        // Crea un'entità di testo 3D per la misurazione
        let textMesh = MeshResource.generateText(
            "\(String(format: "%.2f", measurementInMeters)) m",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.1),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail)
        
        let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        
        // Scala e posiziona il testo
        textEntity.scale = [0.1, 0.1, 0.1]
        textEntity.position = position
        
        // Assicurati che il testo sia sempre rivolto verso la camera
        textEntity.look(at: position + [0, 0, 1], from: position, relativeTo: nil)
        
        anchorEntity?.addChild(textEntity)
        measurementNode = textEntity
    }
    
    private func calculateHeight() {
        guard let start = startPoint, let end = endPoint else { return }
        
        // Calcola la distanza verticale (altezza)
        let heightDifference = abs(end.y - start.y)
        currentHeight = Double(heightDifference)
        
        // Notifica l'aggiornamento dell'altezza
        onHeightUpdate?(currentHeight)
    }
    
    func resetMeasurement() {
        // Rimuovi tutti i marker e le linee
        anchorEntity?.children.removeAll()
        startPoint = nil
        endPoint = nil
        measurementNode = nil
        currentHeight = 0.0
        onHeightUpdate?(0.0)
    }
}

// UIViewRepresentable per la vista AR personalizzata
struct HeightMeasurementARViewRepresentable: UIViewRepresentable {
    @Binding var measuredHeight: Double
    
    func makeUIView(context: Context) -> HeightMeasurementARView {
        let arView = HeightMeasurementARView(frame: .zero)
        arView.onHeightUpdate = { height in
            measuredHeight = height
        }
        return arView
    }
    
    func updateUIView(_ uiView: HeightMeasurementARView, context: Context) {}
}

struct HeightView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var measuredHeight: Double = 0.0
    @State private var isRulerVisible: Bool = true
    
    // Callback per passare la misurazione alla vista chiamante
    var onMeasurementTaken: ((Double) -> Void)?
    
    var body: some View {
        ZStack {
            // Vista AR per la misurazione reale
            HeightMeasurementARViewRepresentable(measuredHeight: $measuredHeight)
                .ignoresSafeArea()
            
            // Overlay con istruzioni e misurazione corrente
            VStack {
                // Visualizzazione della misurazione corrente
                Text("\(String(format: "%.2f", measuredHeight)) m")
                    .font(.system(size: 24, weight: .bold))
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Istruzioni per l'utente
                Text("Tocca per impostare il punto iniziale, poi tocca di nuovo per misurare l'altezza")
                    .font(.caption)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.bottom, 100)
            }
            .padding()
            
            // Pulsanti di controllo
            VStack {
                Spacer()
                
                HStack {
                    // Pulsante indietro
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Pulsante per catturare la misurazione
                    Button(action: {
                        // Salva la misurazione corrente
                        onMeasurementTaken?(measuredHeight)
                        dismiss()
                    }) {
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                            )
                    }
                    .padding()
                    
                    Spacer()
                
                    // Pulsante per resettare la misurazione
                    Button(action: {
                        // Resetta la misurazione utilizzando l'approccio moderno per accedere alla finestra attiva
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first,
                           let arView = window.rootViewController?.view.subviews.first(where: { $0 is HeightMeasurementARView }) as? HeightMeasurementARView {
                            arView.resetMeasurement()
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    HeightView()
}
