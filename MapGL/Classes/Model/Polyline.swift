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

open class Polyline {

	public let id: String
	public let points: [CLLocationCoordinate2D]
	let style1: PolylineStyle?
	let style2: PolylineStyle?
	let style3: PolylineStyle?
	weak var delegate: PolylineDelegate?

	public init(
		points: [CLLocationCoordinate2D],
		style1: PolylineStyle? = nil,
		style2: PolylineStyle? = nil,
		style3: PolylineStyle? = nil
	) {
		assert(points.count > 1, "Polyline should countain more than 1 point")
		self.id = UUID().uuidString
		self.points = points
		self.style1 = style1
		self.style2 = style2
		self.style3 = style3
	}

}

protocol PolylineDelegate: AnyObject {
}

extension Polyline: IMapObject {

	func createJSCode() -> String {
		let js = """
		window.addPolyline(
		"\(self.id)",
		[\(self.points.toJS())],
		\(self.style1.jsValue()),
		\(self.style2.jsValue()),
		\(self.style3.jsValue()),
		);
		"""
		return js
	}

}
