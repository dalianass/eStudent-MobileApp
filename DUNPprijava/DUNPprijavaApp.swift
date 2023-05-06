
import SwiftUI

@main
struct DUNPprijavaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserSettings())
//            DefaultScreen()
//                .environmentObject(UserSettings())
        }
    }
}
