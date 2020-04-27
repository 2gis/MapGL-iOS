import CoreLocation

extension CLLocationCoordinate2D: Equatable {

	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}

	func toJS() -> String {
		"[\(self.longitude), \(self.latitude)]"
	}

}

extension Array where Element == CLLocationCoordinate2D {

	func toJS() -> String {
		self.map { $0.toJS() }.joined(separator: ",")
	}

}
