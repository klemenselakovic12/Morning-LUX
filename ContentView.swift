import SwiftUI

struct ContentView: View {
    @StateObject private var cameraController = CameraController()
    @State private var exposureTime: TimeInterval = 0
    @State private var isCalculating = false

    var body: some View {
        VStack {
            CameraView(cameraController: cameraController)
            Text("Exposure Time: \(exposureTime, specifier: "%.0f") seconds")
                .padding()
            Button(action: {
                isCalculating = true
                exposureTime = calculateExposureTime(forLux: Double(cameraController.luxValue))
                isCalculating = false
            }) {
                Text(isCalculating ? "Calculating..." : "Start Checking LUX")
            }
        }
    }

    func calculateExposureTime(forLux lux: Double) -> TimeInterval {
        if lux < 1000 {
            return TimeInterval.infinity // Insufficient light for circadian rhythm benefits
        } else if lux < 2500 {
            return 120 * 60 // 2 hours
        } else if lux < 5000 {
            return 60 * 60 // 1 hour
        } else if lux < 10000 {
            return 30 * 60 // 30 minutes
        } else if lux < 20000 {
            return 15 * 60 // 15 minutes
        } else if lux < 30000 {
            return 10 * 60 // 10 minutes
        } else {
            return 5 * 60 // 5 minutes
        }
    }
}
