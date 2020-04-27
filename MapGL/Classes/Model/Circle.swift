import CoreLocation

open class Circle {

	public let id: String
	public let center: CLLocationCoordinate2D
	public let radius: CLLocationDistance
	let strokeColor: UIColor?
	let fillColor: UIColor?
	let strokeWidth: CGFloat?
	let z: Int?
	weak var delegate: CircleDelegate?

	public init(
		center: CLLocationCoordinate2D,
		radius: CLLocationDistance,
		strokeColor: UIColor? = nil,
		strokeWidth: CGFloat? = nil,
		fillColor: UIColor? = nil,
		z: Int? = nil
	) {
		self.id = UUID().uuidString
		self.center = center
		self.radius = radius
		self.strokeColor = strokeColor
		self.strokeWidth = strokeWidth
		self.fillColor = fillColor
		self.z = z
	}

}

protocol CircleDelegate: AnyObject {
}

extension Circle: IMapObject {

	func createJSCode() -> String {
		let js = """
		window.addCircle(
		[\(self.center.longitude), \(self.center.latitude)],
		"\(self.radius)",
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
