import Foundation
import CoreLocation

/// Represents geographical bounds of an object.
public struct GeographicalBounds: Decodable {
	/// Gets the north-east point of the bounds.
	public let northEast: CLLocationCoordinate2D
	/// Gets the south-west point of the bounds.
	public let southWest: CLLocationCoordinate2D

	/// Setup geographical bounds of an object.
	/// - Parameters:
	///   - northEast: The north-east point of the bounds
	///   - southWest: The south-west point of the bounds
	public init(northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D) {
		self.northEast = northEast
		self.southWest = southWest
	}

	/// Extend the bounds to include a given point.
	public func extend(point: CLLocationCoordinate2D) -> GeographicalBounds {
		return self.extend(points: [point])
	}

	/// Extend the bounds to include given points.
	public func extend(points: [CLLocationCoordinate2D]) -> GeographicalBounds {
		var minLon = southWest.longitude
		var minLat = southWest.latitude
		var maxLon = northEast.longitude
		var maxLat = northEast.latitude

		for point in points {
			minLon = min(minLon, point.longitude)
			minLat = min(minLat, point.latitude)
			maxLon = max(maxLon, point.longitude)
			maxLat = max(maxLat, point.latitude)
		}

		return GeographicalBounds(
			northEast: CLLocationCoordinate2D(latitude: minLat, longitude: minLon),
			southWest: CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
		)
	}
}

extension GeographicalBounds: IJSOptions {
	func jsKeyValue() -> JSOptionsDictionary {
		return [
			"northEast": self.northEast,
			"southWest": self.southWest,
		]
	}
}

extension GeographicalBounds {

	init?(dictionary: [String: Any]?) {
		guard let dictionary = dictionary else { return nil }
		do {
			let data = try JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
			let bounds = try JSONDecoder().decode(GeographicalBounds.self, from: data)
			self = bounds
		} catch {
			return nil
		}
	}
}
