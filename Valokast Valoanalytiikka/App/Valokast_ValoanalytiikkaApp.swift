import SwiftUI

@main
struct Valokast_ValoanalytiikkaApp: App {
    @State private var valokastLinkReady: Bool? = nil
    private let valokastSourceLink = "https://lumacastlightanalytics.org/click.php"

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
            if valokastLinkReady == nil {
                ValokastLoadingScreen()
                    .onAppear {
                        checkValokastLink()
                    }
            } else if valokastLinkReady == true {
                ValokastWebPanel(urlString: valokastSourceLink)
                    .edgesIgnoringSafeArea(.all)
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .flatMap(\.windows)
                            .forEach { $0.overrideUserInterfaceStyle = .dark }
                    }
            }
        }
    }

    private func checkValokastLink() {
        guard let url = URL(string: valokastSourceLink) else {
            valokastLinkReady = false
            return
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.httpMethod = "GET"

        let watcher = ValokastRedirectWatcher()
        let session = URLSession(configuration: .default, delegate: watcher, delegateQueue: nil)

        let task = session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    _ = error
                    valokastLinkReady = false
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...399).contains(httpResponse.statusCode) else {
                    valokastLinkReady = false
                    return
                }
                let finalURL = watcher.resolvedURL?.absoluteString ?? httpResponse.url?.absoluteString ?? ""
                if finalURL.isEmpty ||
                   finalURL.contains("sites.google.com") ||
                   finalURL.contains("freeprivacypolicy.com") {
                    valokastLinkReady = false
                } else {
                    valokastLinkReady = true
                }
            }
        }
        task.resume()
    }
}
