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
		guard let list = self[.substructure]?.arrayOfDict else { return nil }
		let properties = list.compactMap { $0.property }
		return properties.isEmpty ? nil : properties
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

		let property = Property(
			name: name,
			types: [instanceType]
		)
		property.description = self.fullXMLDocs?.propertyDescription()
		return property
	}

	var docParams: [SourceKitDict] {
		self[.docParameters] as? [SourceKitDict] ?? []
	}

	func docDescription(for key: String) -> String? {
		guard let discussion = self[key] as? [SourceKitDict],
			let para = discussion.first(where: { $0["Para"] != nil }) else { return nil }
		let docDescription = para["Para"] as? String
		return docDescription
	}

	var fullXMLDocs: String? {
		self[.fullXMLDocs] as? String
	}

	var fully_annotated_decl: String? {
		self["key.fully_annotated_decl"] as? String
	}

	var instanceType: InstanceType? {
		guard let typeName = self[.typeName] as? String else { return nil }
		return InstanceType(name: typeName)
	}

	var objectProperties: Properties? {
		guard let name = self.name else { return nil }
		let properties = Properties(name: name)
		print("Name>>>>>\(name)")
		properties.properties = self.properties

		if let pps = self.properties {
			for property in pps {
				if property.description == nil {
					print("Warning: Property \(name).\(property.name) missing description")
				}
			}
		}
		properties.inherits = self.inherited
		#warning("properties.implement")
		let methods = self.methods
		properties.methods = methods?.filter({ !$0.name.hasPrefix("init") })
		properties.constructorMethods = methods?.filter({ $0.name.hasPrefix("init") })

		return properties
	}

	var methods: [Method]? {
		guard let properties = self[.substructure]?.arrayOfDict else { return nil }
		let methods = properties.compactMap { $0.method }
		return methods.isEmpty ? nil : methods
	}

	var method: Method? {
//		print(">>>>>\(self.kind) \(self.accessibility) \(self.name)")
		guard self.kind == .functionMethodInstance,
			self.accessibility?.isValidForExport == true else { return nil }

		let fully_annotated_decl = self.fully_annotated_decl
		if let fully_annotated_decl = fully_annotated_decl {

			let method =
				fully_annotated_decl.parseMethod() ??
				fully_annotated_decl.parseConstructor()

			if method == nil {
				assertionFailure("Should be documented: \(fully_annotated_decl)")
			}
			if let doc = self.fullXMLDocs {
				method?.fill(with: doc)
			}
			return method
		}
		return nil
	}

	var typeName: String? {
		self[.typeName] as? String
	}

	var inherited: [InstanceType]? {
		guard let inherited = self[.inheritedtypes] as? SourceKitDict,
			let name = inherited.name else { return nil }
		return [InstanceType(name: name)]
	}

}

typealias SourceKitDict = [String: SourceKitRepresentable]

extension SourceKitRepresentable {

	var dictionary: SourceKitDict? {
		return self as? SourceKitDict
	}
	var array: [SourceKitRepresentable]? {
		return self as? [SourceKitRepresentable]
	}
	var arrayOfDict: [SourceKitDict]? {
		return self as? [SourceKitDict]
	}
}
