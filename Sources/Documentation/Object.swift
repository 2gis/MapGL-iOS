enum ObjectType: String, Codable {
	case `class`
	case method
	case interface
	case typeAlias
	case enumeration
	case `struct`
	case `extension`
}

struct InstanceType: Codable {
	let name: String
	let refLink: String?
}

struct Method: Codable {
	let name: String
	let description: String?
	var isConstructor: Bool?
	var parameters: [Property]
	let result: ReturnResult
}

struct Property: Codable {
	let name: String
	var description: String?
	let types: [InstanceType]
	var isOptional: Bool?
}

struct Properties: Codable {
	let name: String
	let description: String?
	/// Class
	var constructorMethod: Method?
	var methods: [Method]?
	var implement: [InstanceType]?
	/// Interface
	var inherits: [InstanceType]?
	var properties: [Property]?
	/// Method
	var isConstructor: Bool?
	var parameters: [Property]?
	var result: ReturnResult?
}

struct Object: Codable {
	let type: ObjectType
	let props: Properties
}

struct Documentation: Codable {
	struct Config: Codable {
		var textProvider: String = "md"
	}
	private let config: Config = Config()
	let refMap: [String: Object]
}

struct ReturnResult: Codable {
	var description: String?
	var types: [InstanceType]
}

