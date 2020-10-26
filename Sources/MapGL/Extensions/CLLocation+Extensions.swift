import CoreLocation

extension CLLocationCoordinate2D: Equatable {

	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}

}

extension CLLocationCoordinate2D: IJSValue {
	func jsValue() -> String {
		"[\(self.longitude),\(self.latitude)]"
	}
}

extension CLLocationDistance: IJSValue {
	func jsValue() -> String { "\(self)" }
}

extension CLLocationCoordinate2D: Decodable {
	 public init(from decoder: Decoder) throws {
		 var container = try decoder.unkeyedContainer()
		 let longitude = try container.decode(CLLocationDegrees.self)
		 let latitude = try container.decode(CLLocationDegrees.self)
		 self.init(latitude: latitude, longitude: longitude)
	 }
 }
