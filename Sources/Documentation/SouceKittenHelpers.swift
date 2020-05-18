import SourceKittenFramework

enum Accessibility: String {
	case `public` = "source.lang.swift.accessibility.public"
	case `open` = "source.lang.swift.accessibility.open"
	case `internal` = "source.lang.swift.accessibility.internal"
	case `private` = "source.lang.swift.accessibility.private"

	init?(_ skr: SourceKitRepresentable?) {
		guard let str = skr as? String, let accessibility = Accessibility(rawValue: str) else { return nil }
		self = accessibility
	}

	var isValidForExport: Bool {
		return self == .public || self == .open
	}

}

extension SwiftDeclarationKind {

	func objectType() -> ObjectType? {
		switch self {
			case .class: return .class
			case .extension: return .extension
			case .enum: return .enumeration
			case .protocol: return .interface
			case .functionMethodInstance: return .method
			case .typealias: return .typeAlias
			case .struct: return .struct
			default: return nil
		}
	}

}

extension SwiftDocKey {
	static let accessibility = "key.accessibility"
}

extension Dictionary where Key == String, Value == SourceKitRepresentable {

	subscript(key: SwiftDocKey) -> SourceKitRepresentable? {
		return self[key.rawValue]
	}

	var name: String? {
		self[.name] as? String
	}
	var kind: SwiftDeclarationKind? {
		guard let kind = self[.kind] as? String else { return nil }
		return SwiftDeclarationKind(rawValue: kind)
	}

	var properties: [Property]? {
		guard let properties = self[.substructure]?.arrayOfDict else { return nil }
		return properties.compactMap { $0.property }
	}
	var accessibility: Accessibility? {
		guard let accessibility = self[SwiftDocKey.accessibility] as? String else { return nil }
		return Accessibility(rawValue: accessibility)
	}

	var property: Property? {
		guard self.kind == .varInstance,
			self.accessibility?.isValidForExport == true,
			let name = self.name,
			let instanceType = self.instanceType else { return nil }

		return Property(
			name: name,
			description: self.fullXMLDocs,
			types: [instanceType],
			isOptional: nil
		)
	}

	var fullXMLDocs: String? {
		self[.fullXMLDocs] as? String
	}

	var instanceType: InstanceType? {
		guard let typeName = self[.typeName] as? String else { return nil }
		return InstanceType(name: typeName, refLink: nil)
	}

	var objectProperties: Properties? {
		guard let name = self.name else { return nil }
		var properties = Properties(name: name, description: nil)
		properties.properties = self.properties
		return properties
	}



}

extension SourceKitRepresentable {

	var dictionary: [String: SourceKitRepresentable]? {
		return self as? [String: SourceKitRepresentable]
	}
	var array: [SourceKitRepresentable]? {
		return self as? [SourceKitRepresentable]
	}
	var arrayOfDict: [[String: SourceKitRepresentable]]? {
		return self as? [[String: SourceKitRepresentable]]
	}
}
