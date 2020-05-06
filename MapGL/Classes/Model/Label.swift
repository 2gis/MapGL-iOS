import CoreLocation

/// Polyline map object
open class Label: MapObject {

	public let center: CLLocationCoordinate2D
	public let text: String
	let color: UIColor
	let fontSize: CGFloat

	public init(
		id: String = UUID().uuidString,
		center: CLLocationCoordinate2D,
		color: UIColor,
		text: String,
		fontSize: CGFloat
	) {
		self.center = center
		self.color = color
		self.text = text
		self.fontSize = fontSize
		super.init(id: id)
	}

}

extension Label: IHideable {}

extension Label {

	func jsCode() -> String {
		return """
		{
		id: "\(self.id)",
		coordinates: \(self.center.toJS()),
		color: \(self.color.jsValue()),
		text: '\(self.text)',
		fontSize: \(self.fontSize),
		}
		"""
	}

	override func createJSCode() -> String {
		let js = """
		window.addLabel(\(self.jsCode()));
		"""
		return js
	}

}
