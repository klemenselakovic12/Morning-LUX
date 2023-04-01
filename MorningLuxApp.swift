import SwiftUI

@main
struct MorningLuxApp: App {
    @StateObject private var cameraController = CameraController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cameraController)
        }
    }
}
