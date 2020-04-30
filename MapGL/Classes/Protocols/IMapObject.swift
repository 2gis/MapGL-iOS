@objc public protocol IMapObject {
	var id: String { get }
}

protocol IJSMapObject: IMapObject {
	func createJSCode() -> String
	func destroyJSCode() -> String
}

extension IJSMapObject {

	func destroyJSCode() -> String {
		let js = """
		window.destroyObject("\(self.id)");
		"""
		return js
	}

}
