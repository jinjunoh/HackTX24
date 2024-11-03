import SwiftUI
import ARKit
import SceneKit
import AVFoundation

struct ARView: UIViewRepresentable {
    let arView = ARSCNView(frame: .zero)

    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        arView.scene = SCNScene()

        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

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
    @State private var showProfileView = false        // Track if profile view should be shown
    @State private var isFlashEnabled = false         // Track if flash mode is enabled
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
                    // Top icons (like profile icon for showing ProfileView)
                    HStack {
                        Button(action: {
                            showProfileView = true // Show the profile view when tapped
                        }) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Flash toggle button
                        Button(action: {
                            isFlashEnabled.toggle() // Toggle flash mode
                        }) {
                            ZStack {
                                // Circle with conditional border and fill color
                                Circle()
                                    .fill(isFlashEnabled ? Color.yellow : Color.clear) // Yellow fill if enabled, transparent otherwise
                                    .overlay(
                                        Circle()
                                            .stroke(isFlashEnabled ? Color.clear : Color.white, lineWidth: 2) // White border if off, none if on
                                    )
                                
                                // Lightning bolt icon with conditional background color to create a "cutout" effect
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(isFlashEnabled ? Color.black.opacity(0.5) : Color.white) // Transparent effect when flash is on
                                    .blendMode(isFlashEnabled ? .destinationOut : .normal) // "Cutout" effect on yellow background
                            }
                            .frame(width: 28, height: 28)
                        }

                    }
                    .padding(.horizontal, 30)  // Added padding for overall margin
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Center capture button with left and right filler icons
                    HStack {
                        Button(action: {
                            // Left icon action
                        }) {
                            Image(systemName: "person.2.circle")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Capture button with double-flash effect
                        Button(action: {
                            captureWithDoubleFlash()  // Capture screenshot with double flash effect
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
                    .padding(.horizontal, 30)  // Added padding for bottom icons
                    .padding(.bottom, 50)
                }
            }
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()  // The profile view appears as a pop-up
        }
    }
    
    // Capture the screenshot with double-flash effect
    func captureWithDoubleFlash() {
        guard isFlashEnabled else { // Only flash if flash mode is enabled
            takeScreenshot()
            return
        }
        
        // Perform double flash
        toggleFlash(on: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toggleFlash(on: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                toggleFlash(on: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    toggleFlash(on: false)
                    takeScreenshot() // Take screenshot after the double flash
                }
            }
        }
    }
    
    // Take the screenshot and show it in the UI
    func takeScreenshot() {
        if let screenshot = arView.takeScreenshot() {
            capturedImage = screenshot  // Show the captured image
            print("Screenshot captured!")
        }
    }

    // Toggle the flashlight on or off
    func toggleFlash(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("Flashlight not available on this device.")
            return
        }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Failed to toggle flashlight: \(error)")
        }
    }
}
