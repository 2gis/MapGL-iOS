protocol IMapObject {
	var id: String { get }
	func createJSCode() -> String
	func destroyJSCode() -> String
}

extension IMapObject {

	func destroyJSCode() -> String {
		let js = """
		window.destroyObject("\(self.id)");
		"""
		return js
	}

}
