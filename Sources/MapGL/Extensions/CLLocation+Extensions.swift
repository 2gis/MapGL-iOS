import CoreLocation

extension CLLocationCoordinate2D: Equatable {

	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}

}

extension CLLocationCoordinate2D: IJSValue {
	func jsValue() -> String {
		"[\(self.longitude), \(self.latitude)]"
	}
}
