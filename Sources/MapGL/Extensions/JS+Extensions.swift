import UIKit.UIColor

private enum JS {
	static let undefined = "undefined"
}

protocol IJSValue {
	func jsValue() -> String
}

extension Optional: IJSValue where Wrapped: IJSValue {
	func jsValue() -> String { self?.jsValue() ?? JS.undefined }
}

extension String: IJSValue {
	func jsValue() -> String { "\"\(self)\"" }
}

extension Array: IJSValue where Element: IJSValue {
	func jsValue() -> String {
		let js = "[\(self.map({ $0.jsValue() }).joined(separator: ","))]"
		return js
	}
}
extension Array where Element == IJSValue {
	func jsValue() -> String {
		let js = "[\(self.map({ $0.jsValue() }).joined(separator: ","))]"
		return js
	}
}

extension Bool: IJSValue {
	func jsValue() -> String { self ? "true" : "false" }
}

extension Int: IJSValue {
	func jsValue() -> String { "\(self)" }
}

extension CGFloat: IJSValue {
	func jsValue() -> String { "\(self)" }
}

extension UIColor: IJSValue {
	func jsValue() -> String { self.hexString().jsValue() }
}

extension PolylineStyle: IJSValue {
	func jsValue() -> String {
		"\(self.color.jsValue()),\(self.width.jsValue()),\(self.z.jsValue())"
	}
}

extension Optional where Wrapped == PolylineStyle {
	func jsValue() -> String {
		return self?.jsValue() ?? "\(JS.undefined),\(JS.undefined),\(JS.undefined)"
	}
}
