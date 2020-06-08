class AppleReferenceMap {

	static let swiftPrimitives: Set<String> = [
		"String", "Int", "Double", "Array", "Dictionary", "Optional",
	]

	func reference(for name: String) -> String? {
		if name.hasPrefix("UI") {
			return "https://developer.apple.com/documentation/uikit/\(name)"
		} else if name.hasPrefix("NS") {
			return "https://developer.apple.com/documentation/objectivec/\(name)"
		} else if name.hasPrefix("CG") {
			return "https://developer.apple.com/documentation/coregraphics/\(name)"
		} else if name.hasPrefix("CL") {
			return "https://developer.apple.com/documentation/corelocation/\(name)"
		} else if AppleReferenceMap.swiftPrimitives.contains(name) {
			return "https://developer.apple.com/documentation/swift/\(name)"
		}
		return nil
	}

}
