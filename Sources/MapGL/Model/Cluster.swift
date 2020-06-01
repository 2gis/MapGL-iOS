import CoreLocation

/// A class that provides markers clustering functionality.
open class Cluster: MapObject {

	/// Markers in clusterer 
	public var markers: [Marker] {
		didSet {
			self.updateMarkers()
		}
	}
	private let radius: CLLocationDistance

	public init(
		id: String = NSUUID().uuidString,
		radius: CLLocationDistance,
		markers: [Marker]
	) {
		self.radius = radius
		self.markers = markers
		super.init(id: id)
	}

}

extension Cluster {

	override func createJSCode() -> String {
		return """
		window.addCluster("\(self.id)", \(self.radius), \(self.markers.jsValue()));
		"""
	}

	private func updateMarkers() {
		let js = """
		window.updateCluster(
		"\(self.id)",
		\(self.markers.jsValue())
		);
		"""
		self.delegate?.evaluateJS(js)
	}

}
