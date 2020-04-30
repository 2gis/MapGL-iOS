import CoreLocation

open class PolylineStyle {
	let color: UIColor
	let width: CGFloat
	let z: Int?

	public init(color: UIColor, width: CGFloat, z: Int? = nil) {
		self.color = color
		self.width = width
		self.z = z
	}
}

open class Polyline: MapObject {

	public let points: [CLLocationCoordinate2D]
	let style1: PolylineStyle?
	let style2: PolylineStyle?
	let style3: PolylineStyle?

	public init(
		id: String = UUID().uuidString,
		points: [CLLocationCoordinate2D],
		style1: PolylineStyle? = nil,
		style2: PolylineStyle? = nil,
		style3: PolylineStyle? = nil
	) {
		assert(points.count > 1, "Polyline should countain more than 1 point")
		self.points = points
		self.style1 = style1
		self.style2 = style2
		self.style3 = style3
		super.init(id: id)
	}

}

extension Polyline {

	func jsCode() -> String {
		return """
		{
		id: "\(self.id)",
		coordinates: [\(self.points.toJS())],
		color: \((self.style1?.color).jsValue()),
		width: \((self.style1?.width).jsValue()),
		zIndex: \((self.style1?.z).jsValue()),
		color2: \((self.style2?.color).jsValue()),
		width2: \((self.style2?.width).jsValue()),
		zIndex2: \((self.style2?.z).jsValue()),
		color3: \((self.style3?.color).jsValue()),
		width3: \((self.style3?.width).jsValue()),
		zIndex3: \((self.style3?.z).jsValue()),
		}
		"""
	}

	override func createJSCode() -> String {
		let js = """
		window.addPolyline(\(self.jsCode()));
		"""
		return js
	}

}
