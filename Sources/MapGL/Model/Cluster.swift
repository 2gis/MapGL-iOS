import CoreLocation
import CoreGraphics

/// A class that provides markers clustering functionality.
open class Cluster: MapObject {

	/// Markers in clusterer 
	public var markers: [Marker] {
		didSet {
			self.updateMarkers()
		}
	}
	private let radius: CGFloat

	/// Creates new cluster on map
	/// - Parameters:
	///   - id: Unique object id
	///   - radius: Clustering radius in points.
	///   - markers: Cluster markers
	public init(
		id: String = NSUUID().uuidString,
		radius: CGFloat,
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
		self.evaluateJS(js)
	}

}
