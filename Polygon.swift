import CoreLocation

open class Polygon {

	public let id: String
	public let points: [CLLocationCoordinate2D]
	let strokeColor: UIColor?
	let fillColor: UIColor?
	let strokeWidth: CGFloat?
	let z: Int?
	weak var delegate: PolygonDelegate?

	public init(
		points: [CLLocationCoordinate2D],
		strokeColor: UIColor? = nil,
		strokeWidth: CGFloat? = nil,
		fillColor: UIColor? = nil,
		z: Int? = nil
	) {
		assert(points.count > 2, "Polygon should countain more than 2 points")
		self.id = UUID().uuidString
		self.points = points
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		self.strokeWidth = strokeWidth
		self.z = z
	}

}

protocol PolygonDelegate: AnyObject {
}

extension Polygon: IMapObject {

	func createJSCode() -> String {
		var polygonPoints = self.points
		// Polygon should end with same point as starts
		if !polygonPoints.isEmpty, polygonPoints.first != polygonPoints.last {
			polygonPoints.append(polygonPoints[0])
		}
		let points = polygonPoints.toJS()
		let js = """
		window.addPolygon(
		[[\(points)]],
		"\(self.id)",
		\(self.strokeWidth.jsValue()),
		\(self.fillColor.jsValue()),
		\(self.strokeColor.jsValue()),
		\(self.z.jsValue()),
		);
		"""
		return js
	}

}
