import CoreLocation

open class Circle {

	public let id: String
	public let center: CLLocationCoordinate2D
	public let radius: CLLocationDistance
	weak var delegate: CircleDelegate?

	public init(
		center: CLLocationCoordinate2D,
		radius: CLLocationDistance
	) {
		self.id = UUID().uuidString
		self.center = center
		self.radius = radius
	}

}

protocol CircleDelegate: AnyObject {
}
