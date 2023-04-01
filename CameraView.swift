import SwiftUI

struct CameraView: View {
    @ObservedObject var cameraController: CameraController
    
    var body: some View {
        CameraPreviewView(cameraController: cameraController)
            .onAppear {
                cameraController.startSession()
            }
            .onDisappear {
                cameraController.stopSession()
            }
    }
}
