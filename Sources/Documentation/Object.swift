enum ObjectType: String, Codable {
	case `class`
	case method
	case interface
	case typeAlias
	case enumeration
	case `struct`
	case `extension`
}

class InstanceType: Codable {
	let name: String
	var refLink: String?
	var pureName: String {
		self.name
			.replacingOccurrences(of: "?", with: "")
			.replacingOccurrences(of: "[", with: "")
			.replacingOccurrences(of: "]", with: "")
	}

	init(name: String) {
		self.name = name
	}
}

class Method: Codable {
	let name: String
	var description: String?
	var parameters: [Property]
	var result: ReturnResult?
	var paramsSignature: String?
	private let isConstructor: Bool = false

	init(name: String, parameters: [Property], result: ReturnResult?) {
		self.name = name
		self.parameters = parameters
		self.result = result
	}
}

class Property: Codable {
	let name: String
	let label: String?
	let types: [InstanceType]
	var description: String?
	var isOptional: Bool?

	init(name: String, label: String?, types: [InstanceType]) {
		self.name = name
		self.label = label
		self.types = types
	}

}

class Properties: Codable {
	let name: String
	var description: String?
	/// Class
	var constructorMethods: [Method]?
	var methods: [Method]?
	var implement: [InstanceType]?
	/// Interface
	var inherits: [InstanceType]?
	var properties: [Property]?
	/// Method
	var isConstructor: Bool?
	/// Method only
	var parameters: [Property]?
	var result: ReturnResult?
	init(name: String) {
		self.name = name
	}
}

class Object: Codable {
	let type: ObjectType
	var props: Properties
	var accessibility: Accessibility?
	enum CodingKeys: String, CodingKey {
		case type
		case props
	}
	init(type: ObjectType, props: Properties) {
		self.type = type
		self.props = props
	}
}

struct Documentation: Codable {
	struct Config: Codable {
		var textProvider: String = "md"
	}
	private let config: Config = Config()
	let refMap: [String: Object]
}

class ReturnResult: Codable {
	var types: [InstanceType]
	var description: String?
	init(types: [InstanceType]) {
		self.types = types
	}
}

