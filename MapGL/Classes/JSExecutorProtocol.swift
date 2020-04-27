import Foundation

protocol JSExecutorProtocol : class {
	func evaluateJavaScript(_ javaScriptString: String, completion: ((Any?, Error?) -> Void)?)
}
