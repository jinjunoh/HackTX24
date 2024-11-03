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
        return arView.snapshot()
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
                                .padding(.top, 60)      // Adjusted top padding to move below the status bar
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                arView
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top icons (like search and profile icons in the Snapchat example)
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
                    .padding(.horizontal, 30)  // Added padding for overall margin
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Center capture button with left and right filler icons
                    HStack {
                        // Left icon (e.g., friends icon)
                        Button(action: {
                            // Left icon action
                        }) {
                            Image(systemName: "person.2.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Capture button
                        Button(action: {
                            if let screenshot = arView.takeScreenshot() {
                                capturedImage = screenshot  // Show the captured image
                                print("Screenshot captured!")
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
                        
                        // Right icon (e.g., discover icon)
                        Button(action: {
                            // Right icon action
                        }) {
                            Image(systemName: "circle.grid.3x3.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)  // Added padding for bottom icons
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
