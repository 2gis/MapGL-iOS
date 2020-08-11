class ReferenceVisitor {
	private let appleReferenceMap = AppleReferenceMap()
	private let existingReferences: [String: String]

	init(existingReferences: [String: String]) {
		self.existingReferences = existingReferences
	}

	func visit(_ type: InstanceType) {
		let name = type.pureName
		// сначала пробуем подобрать ссылку на свифтовую документацию, потом пробуем подставить нашу
		let refLink = self.appleReferenceMap.reference(for: name) ?? self.existingReferences[name]
		type.refLink = refLink
	}

}

extension Object {

	func refMap() -> String {
		"/en/ios/webgl/maps/reference/\(self.props.name)"
	}

	func addMissingRefs(_ visitor: ReferenceVisitor) {
		self.props.constructorMethods?.forEach({ $0.addMissingRefs(visitor) })
		self.props.implement?.addMissingRefs(visitor)
		self.props.inherits?.addMissingRefs(visitor)
		self.props.methods?.forEach({ $0.addMissingRefs(visitor) })
		self.props.properties?.forEach({ $0.addMissingRefs(visitor) })
		self.props.parameters?.forEach({ $0.addMissingRefs(visitor) })
		self.props.result?.addMissingRefs(visitor)
	}

}

extension Method {
	func addMissingRefs(_ visitor: ReferenceVisitor) {
		self.parameters.forEach { $0.addMissingRefs(visitor) }
		self.result?.addMissingRefs(visitor)
	}
}

extension Property {
	func addMissingRefs(_ visitor: ReferenceVisitor) {
		self.types.addMissingRefs(visitor)
	}
}

extension InstanceType {
	func addMissingRefs(_ visitor: ReferenceVisitor) {
		visitor.visit(self)
	}
}

extension ReturnResult {
	func addMissingRefs(_ visitor: ReferenceVisitor) {
		self.types.addMissingRefs(visitor)
	}
}

extension Array where Element == InstanceType {
	func addMissingRefs(_ visitor: ReferenceVisitor) {
		self.forEach { $0.addMissingRefs(visitor) }
	}
}
