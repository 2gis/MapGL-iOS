@testable import MapGL

class JSExecutor : JSExecutorProtocol {

	var javaScriptString: String?
	var invocationsCount: Int = 0

	func evaluateJavaScript(_ javaScriptString: String, completion: ((Any?, Error?) -> Void)?) {
		self.javaScriptString = javaScriptString
		self.invocationsCount = self.invocationsCount + 1
	}

}

