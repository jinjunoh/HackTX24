import SwiftUI
import ARKit
import SceneKit
import Vision
import CoreImage
import Foundation

struct ARView: UIViewRepresentable {
    let arView = ARSCNView(frame: .zero)
    @Binding var translatedText: String
    @Binding var targetLanguage: String

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
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARView
        init(_ parent: ARView) {
            self.parent = parent
        }

        // Detect text in the captured image
        func detectText(in image: UIImage) {
            guard let cgImage = image.cgImage else { return }

            // Convert to Grayscale
            let ciImage = CIImage(cgImage: cgImage)
            let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")
            grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)

            guard let grayscaleImage = grayscaleFilter?.outputImage else { return }

            // Apply Thresholding
            let thresholdFilter = CIFilter(name: "CIColorControls")
            thresholdFilter?.setValue(grayscaleImage, forKey: kCIInputImageKey)
            thresholdFilter?.setValue(1.0, forKey: kCIInputContrastKey)

            let context = CIContext()
            guard let outputCGImage = context.createCGImage(thresholdFilter?.outputImage ?? grayscaleImage, from: grayscaleImage.extent) else { return }
            let processedImage = UIImage(cgImage: outputCGImage)

            // Perform OCR using Vision and collect all recognized text
            let requestHandler = VNImageRequestHandler(cgImage: processedImage.cgImage!, options: [:])
            let textDetectionRequest = VNRecognizeTextRequest { (request, error) in
                if let error = error {
                    print("Text recognition error: \(error)")
                    return
                }

                // Collect all recognized texts
                var recognizedTexts = [String]()
                if let observations = request.results as? [VNRecognizedTextObservation] {
                    for observation in observations {
                        if let topCandidate = observation.topCandidates(1).first {
                            recognizedTexts.append(topCandidate.string)
                        }
                    }
                }

                // Call translateTexts with all recognized strings at once
                self.translateTexts(recognizedTexts) { translatedTexts in
                    if let translatedTexts = translatedTexts {
                        DispatchQueue.main.async {
                            // Join all translations into a single string for display
                            self.parent.translatedText = translatedTexts.joined(separator: " ")
                        }
                    } else {
                        print("Translation failed")
                    }
                }
            }

            do {
                try requestHandler.perform([textDetectionRequest])
            } catch {
                print("Failed to perform text detection: \(error)")
            }
        }

        // Translate multiple texts in a single API call
        private func translateTexts(_ texts: [String], targetLanguage: String = "es", completion: @escaping ([String]?) -> Void) {
            let apiKey = "AIzaSyCvzRLc_rLKcmka_4TtuWm0huRrWvz03Tk"  // Replace with your actual API key
            let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // Set up parameters with an array of texts
            let parameters: [String: Any] = [
                "q": texts,
                "target": parent.targetLanguage,
                "format": "text"
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }

                // Parse the JSON response
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataObject = jsonResponse["data"] as? [String: Any],
                   let translationsArray = dataObject["translations"] as? [[String: Any]] {

                    // Extract translated texts from the response
                    let translatedTexts = translationsArray.compactMap { $0["translatedText"] as? String }
                    completion(translatedTexts)
                } else {
                    print("Failed to parse translation response.")
                    completion(nil)
                }
            }

            task.resume()
        }
    }

    func takeScreenshot() -> UIImage? {
        return arView.snapshot()
    }
}

struct ARContentView: View {
    @State private var capturedImage: UIImage? = nil  // Track if a screenshot has been taken
    @State private var showPopup = false
    @State private var translatedText: String = ""  // Holds the translated text for pop-up display
    @State private var showProfileSheet = false
    @State private var showLoginSheet = false
    @State private var isLoggedIn = UserDefaults.standard.string(forKey:"savedUsername") != nil
    @State private var isFlashEnabled = false
    @State private var targetLanguage: String = "en"
    @State private var showLanguagePicker = false
    
    var body: some View {
        let arView = ARView(translatedText: $translatedText, targetLanguage: $targetLanguage) // Pass the target language
        ZStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                arView
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Button(action: {
                            showProfileSheet = true
                            print("Profile button pressed")
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
                                capturedImage = screenshot
                                arView.makeCoordinator().detectText(in: screenshot)
                                showPopup = true
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
                            showLanguagePicker.toggle()
                        }) {
                            Image(systemName: "globe")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
            if showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(alignment: .trailing) {
                        Button(action: {
                            showPopup = false
                            capturedImage = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        .padding([.top, .trailing])

                        ScrollView { // Wrap the Text in a ScrollView
                            Text(translatedText.isEmpty ? "Translating..." : translatedText)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(16)
                                .padding(.horizontal) // Padding for horizontal spacing
                                .font(.custom("Lato", size: 20))
                        }
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.5) // Limit to half the screen height
                        .frame(minHeight: 100)
                    }
                    .padding()
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(25)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                }
            }//end showPopup
        }
        .sheet(isPresented: $showProfileSheet){
            ProfileView(isLoggedIn: $isLoggedIn, showProfileSheet: $showProfileSheet, onLogout: handleLogout)
        }
        .sheet(isPresented: $showLoginSheet){
            LoginSignupView(isLoggedIn: $isLoggedIn, showLoginSheet: $showLoginSheet).interactiveDismissDisabled(true)
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePicker(selectedLanguage: $targetLanguage)
        }
        .animation(.default, value: showPopup)
    }
    private func handleLogout(){
        isLoggedIn = false
        showProfileSheet = false
        showLoginSheet = true
    }
}

struct LanguagePicker: View {
    @Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode // Access presentation mode for dismissal
    let languages = [
        ("English", "en"),
        ("Spanish", "es"),
        ("French", "fr"),
        ("German", "de"),
        ("Chinese", "zh"),
        ("Russian", "ru"),
        // Add more languages as needed
    ]

    var body: some View {
        NavigationView {
            List(languages, id: \.1) { language in
                Button(action: {
                    selectedLanguage = language.1 // Set the selected language code
                    print("Selected language: \(selectedLanguage)") // Debug print
                    presentationMode.wrappedValue.dismiss() // Dismiss the sheet after selection
                }) {
                    Text(language.0) // Display the language name
                }
            }
            .navigationBarTitle("Select Language", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss() // Dismiss the language picker when "Done" is pressed
            })
        }
    }
}
