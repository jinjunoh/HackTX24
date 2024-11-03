import ARKit
import SwiftUI

private func displayTranslatedText(_ text: String, at position: SCNVector3) {
    // Remove existing anchors and nodes
    parent.arView.session.currentFrame?.anchors.forEach { anchor in
        parent.arView.session.remove(anchor: anchor)
    }
    parent.arView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
    
    // Create the text node
    let textNode = createTextNode(text)
    
    // Add an ARAnchor at the specified position in AR space
    let textAnchor = ARAnchor(transform: simd_float4x4(SCNMatrix4MakeTranslation(position.x, position.y, position.z)))
    parent.arView.session.add(anchor: textAnchor)
    
    // Keep a reference to the anchor’s ID so we can associate it with the node
    parent.arView.scene.rootNode.addChildNode(textNode)
    
    // Position the text node relative to the anchor's location
    textNode.position = position
}

private func createTextNode(_ text: String) -> SCNNode {
    let textGeometry = SCNText(string: text, extrusionDepth: 0.5)
    textGeometry.font = UIFont.systemFont(ofSize: 10)
    textGeometry.firstMaterial?.diffuse.contents = UIColor.white
    
    let textNode = SCNNode(geometry: textGeometry)
    textNode.scale = SCNVector3(0.01, 0.01, 0.01)
    textNode.pivot = SCNMatrix4MakeTranslation(
        Float(textGeometry.boundingBox.max.x - textGeometry.boundingBox.min.x) / 2,
        Float(textGeometry.boundingBox.max.y - textGeometry.boundingBox.min.y) / 2,
        0
    )
    
    return textNode
}
