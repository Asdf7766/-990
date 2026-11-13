import SwiftUI
import WebKit

// 《仕途》— WKWebView shell.
// Loads the bundled web game (Resources/index.html) with no network needed.
// localStorage save (shitu-save-v1) works in WKWebView.
// index.html is a Swift Package resource: it lives in Bundle.module at
// Shitu_Shitu.bundle/Resources/index.html, NOT in Bundle.main.

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        let web = WKWebView(frame: .zero, configuration: config)
        web.isOpaque = true
        web.backgroundColor = .black
        web.scrollView.bounces = false

        let candidates: [URL?] = [
            Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "Resources"),
            Bundle.module.url(forResource: "index", withExtension: "html"),
            Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Resources"),
            Bundle.main.url(forResource: "index", withExtension: "html")
        ]
        for candidate in candidates {
            if let url = candidate {
                web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
                return web
            }
        }
        web.loadHTMLString(
            "<html><body style='background:#fff;color:#000;font-family:sans-serif;padding:40px'>"
            + "<h2>找不到 index.html</h2><p>Bundle.module: \(Bundle.module.bundleURL)</p>"
            + "<p>Bundle.main: \(Bundle.main.bundleURL)</p></body></html>",
            baseURL: nil
        )
        return web
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        WebView().ignoresSafeArea()
    }
}
