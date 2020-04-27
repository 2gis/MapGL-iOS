private enum JS {
	static let undefined = "undefined"
}

protocol IJSValue {
	func jsValue() -> String
}

extension Optional where Wrapped: SignedNumeric {

	func jsValue() -> String {
		return self?.jsValue() ?? JS.undefined
	}

}

extension SignedNumeric {

	func jsValue() -> String {
		return "\(self)"
	}

}

extension UIColor: IJSValue {

	func jsValue() -> String {
		guard let hex = self.hexString() else { return JS.undefined }
		return "\"\(hex)\""
	}

}

extension Optional where Wrapped == UIColor {

	func jsValue() -> String {
		return self?.jsValue() ?? JS.undefined
	}

}

extension PolylineStyle: IJSValue {

	func jsValue() -> String {
		return """
		\(self.color.jsValue()),
		\(self.width.jsValue()),
		\(self.z.jsValue())
		"""
	}

}

extension Optional where Wrapped == PolylineStyle {

	func jsValue() -> String {
		return self?.jsValue() ?? "\(JS.undefined),\(JS.undefined),\(JS.undefined)"
	}

}
