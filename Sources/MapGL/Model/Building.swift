open class Building: MapObject {

	/// Create new instance of firm or building
	/// - Parameter id: 2GIS Firm or building id
	public override init(id: String) {
		super.init(id: id)
	}

}

extension Building: IHideable {

	public func hide() {
		self.delegate?.evaluateJS(self.destroyJSCode())
	}

	public func show() {
		self.delegate?.evaluateJS(self.createJSCode())
	}

}

internal extension Building {

	override func createJSCode() -> String {
		let js = """
		window.showBuilding("\(self.id)");
		"""
		return js
	}

	override func destroyJSCode() -> String {
		let js = """
		window.hideBuilding("\(self.id)");
		"""
		return js
	}

}
