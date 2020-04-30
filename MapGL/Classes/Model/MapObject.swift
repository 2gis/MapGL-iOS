open class MapObject: NSObject {

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

}

protocol IObjectDelegate: AnyObject {
	func evaluateJS(_ js: String)
}
