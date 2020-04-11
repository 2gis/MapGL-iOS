import CoreLocation

open class Circle {

	let id: String
	let center: CLLocationCoordinate2D
	let radius: CLLocationDistance
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
