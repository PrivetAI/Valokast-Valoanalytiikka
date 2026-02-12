import SwiftUI

@main
struct Ice_Feshing_LightApp: App {
    init() {
        // Force dark appearance globally
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { $0.overrideUserInterfaceStyle = .dark }
        }

        // Style navigation bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.10, alpha: 1)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 1.0, green: 0.96, blue: 0.88, alpha: 1)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 1.0, green: 0.96, blue: 0.88, alpha: 1)]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(red: 1.0, green: 0.75, blue: 0.15, alpha: 1)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear {
                    // Ensure dark mode on all windows
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .flatMap(\.windows)
                        .forEach { $0.overrideUserInterfaceStyle = .dark }
                }
        }
    }
}
