import SwiftUI
import ARKit
import SceneKit
import Vision

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
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARView
        init(_ parent: ARView) {
            self.parent = parent
        }
    }

    func takeScreenshot() -> UIImage? {
        return arView.snapshot()
    }
    
    // Detect text in the captured image
    func detectText(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let textDetectionRequest = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Text recognition error: \(error)")
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    let recognizedText = topCandidate.string
                    self.translateText(recognizedText)
                }
            }
        }

        do {
            try requestHandler.perform([textDetectionRequest])
        } catch {
            print("Failed to perform text detection: \(error)")
        }
    }

    // Mock translation function
    private func translateText(_ text: String) {
        let translatedText = "Translated Text Here"  // Mocked translation
        print(text)

        DispatchQueue.main.async {
            self.displayTranslatedText(translatedText)
        }
    }

    // Display translated text as an AR node
    // TODO: not working
    private func displayTranslatedText(_ translatedText: String) {
        print("Displaying func entered")
        let textNode = SCNNode(geometry: createTextGeometry(translatedText))
        textNode.position = SCNVector3(0, 0, -0.5) // Adjust position for better alignment
        arView.scene.rootNode.addChildNode(textNode)
    }

    private func createTextGeometry(_ text: String) -> SCNText {
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.font = UIFont.systemFont(ofSize: 10)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        return textGeometry
    }
}
struct ARContentView: View {
    @State private var capturedImage: UIImage? = nil  // Track if a screenshot has been taken
    let arView = ARView()
    
    var body: some View {
        ZStack {
            // Show AR view or captured image
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // "X" button to go back to AR view
                VStack {
                    HStack {
                        Button(action: {
                            capturedImage = nil // Dismiss the screenshot
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.top, 60)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                arView
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: {
                            // Profile action
                        }) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Flash toggle action
                        }) {
                            Image(systemName: "bolt.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            // Left icon action
                        }) {
                            Image(systemName: "person.2.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if let screenshot = arView.takeScreenshot() {
                                capturedImage = screenshot  // Show the captured image
                                arView.detectText(in: screenshot)  // Trigger text detection
                                print("Screenshot captured and text detection started!")
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
                        
                        Spacer()
                        
                        Button(action: {
                            // Right icon action
                        }) {
                            Image(systemName: "circle.grid.3x3.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
