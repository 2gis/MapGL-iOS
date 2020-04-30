import CoreLocation

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

extension Array where Element == Marker {
	func jsCode() -> String {
		let markers = self.map { $0.jsCode() }.joined(separator: ",")
		return "[\(markers)]"
	}
}

extension Cluster {

	override func createJSCode() -> String {
		return """
		window.addCluster("\(self.id)", \(self.radius), \(self.markers.jsCode()));
		"""
	}

	private func updateMarkers() {
		let js = """
		window.updateCluster(
		"\(self.id)",
		\(self.markers.jsCode())
		);
		"""
		self.delegate?.evaluateJS(js)
	}

}
