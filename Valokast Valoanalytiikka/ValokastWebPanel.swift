import SwiftUI
import WebKit

struct ValokastWebPanel: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        }
        let valokastDisplayPage = WKWebView(frame: .zero, configuration: config)
        valokastDisplayPage.scrollView.bounces = true
        valokastDisplayPage.allowsBackForwardNavigationGestures = true
        if let url = URL(string: urlString) {
            valokastDisplayPage.load(URLRequest(url: url))
        }
        return valokastDisplayPage
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
