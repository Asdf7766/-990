import SwiftUI
import WebKit

// 小圆爸爸专属 — WKWebView shell.
// Loads the bundled web game (Resources/index.html) with no network needed.
// localStorage save (xiaoyuan-dad-save-v1) works in WKWebView.
//
// FIX 2026-11-07: index.html is a Swift Package resource, it lives in
// Bundle.module at XiaoYuanDad_XiaoYuanDad.bundle/Resources/index.html,
// NOT in Bundle.main. The old code used Bundle.main only, so it found
// nothing and the WKWebView stayed black. Now try Bundle.module first.

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        let web = WKWebView(frame: .zero, configuration: config)
        web.isOpaque = true
        web.backgroundColor = .black
        web.scrollView.bounces = false

        // 1) Swift Package resource bundle (the real location)
        // 2) Main bundle, for Xcode-project builds
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
        // If still not found, show an error instead of a black screen.
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
