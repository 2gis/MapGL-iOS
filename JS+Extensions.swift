extension Optional where Wrapped: SignedNumeric {

	func jsValue() -> String {
		guard let value = self else { return "undefined" }
		return "\(value)"
	}

}

extension Optional where Wrapped == UIColor {

	func jsValue() -> String {
		guard let hex = self?.hexString() else { return "undefined" }
		return "\"\(hex)\""
	}

}
