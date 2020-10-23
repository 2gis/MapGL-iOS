import Foundation
import CoreLocation
import UIKit

/// Represents a circle marker on the map.
class CircleMarker: MapObject {

	/// Gets the marker radius.
	let radius: CGFloat?

	/// Gets the marker coordinates.
	let coordinates: CLLocationCoordinate2D

	/// Creates the new instance of the circle marker object.
	///
	/// - Parameters:
	///   - id: Marker uid
	///   - coordinates: Marker geographical coordinates
	///   - radius: Radius of the marker
	init(
		id: String = NSUUID().uuidString,
		coordinates: CLLocationCoordinate2D,
		radius: CGFloat? = nil
	) {
		self.coordinates = coordinates
		self.radius = radius
		super.init(id: id)
	}

}

extension CircleMarker: IJSOptions {

	func jsKeyValue() -> [String : IJSValue] {
		var options: [String : IJSValue] = [
			"id": self.id,
			"coordinates": self.coordinates,
		]
		if let radius = self.radius {
			options["radius"] = radius
		}
		return options
	}

	override func createJSCode() -> String {
		let js = """
		window.addCircleMarker(\(self.jsValue()));
		"""
		return js
	}
}
