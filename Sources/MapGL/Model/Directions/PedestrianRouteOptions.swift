import CoreLocation

/// Pedestrian route method options.
public struct PedestrianRouteOptions {
	/// Array of geographical points [longitude, latitude].
	/// You can set up to 10 points.
	var points: [CLLocationCoordinate2D]
	public init(points: [CLLocationCoordinate2D]) {
		assert(points.count <= 10, "You can set up to 10 points.")
		self.points = points
	}
}

extension PedestrianRouteOptions: IJSValue {
	func jsValue() -> String {
		"{ points: \(self.points.jsValue()) }"
	}
}
