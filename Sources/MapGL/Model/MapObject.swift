import Foundation

/// Base map object class
open class MapObject: NSObject, IMapObject {

	/// Unique object id
	@objc public let id: String
	weak var delegate: IObjectDelegate?

	public init(
		id: String = UUID().uuidString
	) {
		self.id = id
	}

}

@objc extension MapObject: IJSMapObject {

	func createJSCode() -> String {
		assertionFailure("You should override this method")
		return ""
	}

	func destroyJSCode() -> String {
		let js = """
		window.destroyObject("\(self.id)");
		"""
		return js
	}

	func evaluateJS(_ js: String) {
		assert(self.delegate != nil)
		self.delegate?.evaluateJS(js)
	}

}

protocol IObjectDelegate: AnyObject {
	func evaluateJS(_ js: String)
}
