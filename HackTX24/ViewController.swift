//
//  ViewController.swift
//  HackTX24
//
//  Created by Joseph on 11/2/24.
//

import ARKit
import Vision

class ViewController: UIViewController, ARSessionDelegate {
    var sceneView: ARSCNView!
    let textDetectionRequest = VNRecognizeTextRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAR()
        configureTextDetection()
    }
    
    func setupAR() {
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.session.delegate = self
    }
    
    func configureTextDetection() {
        textDetectionRequest.recognitionLevel = .accurate
        textDetectionRequest.usesLanguageCorrection = true
        textDetectionRequest.minimumTextHeight = 0.1
    }
}


