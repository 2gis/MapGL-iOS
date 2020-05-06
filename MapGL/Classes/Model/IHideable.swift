public protocol IHideable: AnyObject {

	/// Hide object from map
	func hide()
	/// Show object on map
	func show()

}

extension IHideable where Self: MapObject {

	public func hide() {
		let js = """
		window.hideObject("\(self.id)");
		"""
		self.delegate?.evaluateJS(js)
	}

	public func show() {
		let js = """
		window.showObject("\(self.id)");
		"""
		self.delegate?.evaluateJS(js)
	}

}
