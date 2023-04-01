import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraController: CameraController
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let videoPreviewLayer = cameraController.videoPreviewLayer {
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
       
