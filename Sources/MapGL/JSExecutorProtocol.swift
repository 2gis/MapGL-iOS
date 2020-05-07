import Foundation

protocol JSExecutorProtocol : AnyObject {
	func evaluateJavaScript(_ javaScriptString: String, completion: ((Any?, Error?) -> Void)?)
}
