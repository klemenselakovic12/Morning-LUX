import AVFoundation
import Combine
import Foundation
import UIKit

class CameraController: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var luxValue: Float = 0.0
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            self.videoPreviewLayer = videoPreviewLayer
            
            captureSession.startRunning()
        } catch {
            print("Error setting up camera: \(error)")
        }
        
        self.captureSession = captureSession
    }
    
    func startSession() {
        captureSession?.startRunning()
    }
    
    func stopSession() {
        captureSession?.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        let exposureValue = cameraImage.averageBrightness()
        DispatchQueue.main.async {
            self.luxValue = exposureValue
        }
    }
}

extension CIImage {
    func averageBrightness() -> Float {
        let totalPixels = extent.width * extent.height
        let context = CIContext()
        let result = context.createCGImage(self, from: extent)
        let rawData = CFDataGetBytePtr(result!.dataProvider!.data)
        
        let channelCount = 4
        let bytesPerRow = result!.bytesPerRow
        let lastPixelIndex = Int(totalPixels) * channelCount
        
        var totalBrightness: Float = 0
        
        for pixelIndex in stride(from: 0, to: lastPixelIndex, by: channelCount) {
            let row = pixelIndex / bytesPerRow
            let col = (pixelIndex % bytesPerRow) / channelCount
            let pixel = rawData![pixelIndex]
            totalBrightness += Float(pixel) * (1.0 / 255.0)
        }
        
        return totalBrightness / Float(totalPixels)
    }
}
