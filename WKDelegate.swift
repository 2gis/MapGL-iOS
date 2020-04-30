import WebKit

class WKDelegate: NSObject {

	var onInitializeMap: (() -> Void)?

}

extension WKDelegate: WKNavigationDelegate {

	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		self.onInitializeMap?()
		self.onInitializeMap = nil
	}
}

extension WKDelegate: WKUIDelegate {

	public func webView(
		_ webView: WKWebView,
		runJavaScriptAlertPanelWithMessage message: String,
		initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void
	) {
		completionHandler()
	}

}
