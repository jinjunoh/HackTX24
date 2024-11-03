import SwiftUI
import ARKit
import SceneKit

struct ARView: UIViewRepresentable {
    let arView = ARSCNView(frame: .zero)

    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        arView.scene = SCNScene()
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, ARSCNViewDelegate {}

    func takeScreenshot() -> UIImage? {
        let snapshot = arView.snapshot()
        return snapshot
    }
}

struct ARContentView: View {
    let arView = ARView()
    
    var body: some View {
        ZStack {
            arView
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Button(action: {
                    if let screenshot = arView.takeScreenshot() {
                        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
                        print("Screenshot captured and saved!")
                    }
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.2), lineWidth: 4)
                        )
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
            }
        }
    }
}
