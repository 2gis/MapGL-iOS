import CoreLocation

open class Polygon {

	let id: String
	let points: [CLLocationCoordinate2D]
	let strokeColor: UIColor?
	let fillColor: UIColor?
	let strokeWidth: CGFloat?
	let z: Int
	weak var delegate: PolygonDelegate?

	public init(
		points: [CLLocationCoordinate2D],
		strokeColor: UIColor? = nil,
		strokeWidth: CGFloat? = nil,
		fillColor: UIColor? = nil,
		z: Int = 0
	) {
		self.id = UUID().uuidString
		self.points = points
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		self.strokeWidth = strokeWidth
		self.z = z
	}

}

protocol PolygonDelegate: AnyObject {

//	func marker(_ marker: Marker, didChangeCoordinates coordinates: CLLocationCoordinate2D)
//	func markerDidHide(_ marker: Marker)
//	func markerDidShow(_ marker: Marker)
//	func markerDidRemove(_ marker: Marker)

}
