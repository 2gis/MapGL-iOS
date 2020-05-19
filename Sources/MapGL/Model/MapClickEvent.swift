import CoreLocation

struct MapClickEvent: Codable {
	struct Target: Codable {
		let id: String
	}
	let lngLat: [Double]
	let point: [Double]
	let target: Target?
}

extension MapClickEvent {

	var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: self.lngLat[1], longitude: self.lngLat[0])
	}

	init?(string: String?) {
		guard let data = string?.data(using: .utf8) else { return nil }
		do {
			let event = try JSONDecoder().decode(MapClickEvent.self, from: data)
			guard event.lngLat.count == 2 else { return nil }
			self = event
		} catch {
			return nil
		}
	}
}
