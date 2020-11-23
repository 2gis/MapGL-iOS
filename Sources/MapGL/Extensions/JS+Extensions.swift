import UIKit.UIColor

private enum JS {
	static let undefined = "undefined"
}

protocol IJSValue {
	func jsValue() -> String
}
typealias JSOptionsDictionary = [String: IJSValue]
protocol IJSOptions: IJSValue {
	func jsKeyValue() -> JSOptionsDictionary
}

extension IJSOptions {
	func jsValue() -> String {
		let values = self.jsKeyValue()
			.sorted { $0.key < $1.key }
			.map { "\($0.key):\($0.value.jsValue())" }
			.joined(separator: ",")
		return "{\(values)}"
	}
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

extension UIImage: IJSValue {
	func jsValue() -> String {
		guard let imageData = self.pngData() else { return JS.undefined }
		let imageString = imageData.base64EncodedString()
		let markerImage = "\"data:image/png;base64,\(imageString)\""
		return markerImage
	}
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
		self?.jsValue() ?? "\(JS.undefined),\(JS.undefined),\(JS.undefined)"
	}
}

extension UIEdgeInsets: IJSValue {
	func jsValue() -> String {
		"[\(self.top),\(self.right),\(self.bottom),\(self.left)]"
	}
}

extension CGSize: IJSValue {
	func jsValue() -> String { "[\(self.width),\(self.height)]" }
}

extension CGPoint: IJSValue {
	func jsValue() -> String { "[\(self.x),\(self.y)]" }
}
