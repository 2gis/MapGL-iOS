import CoreLocation

open class Cluster {

	public let id: String
	private let radius: CLLocationDistance
	public var markers: [Marker]

	public init(
		id: String = NSUUID().uuidString,
		radius: CLLocationDistance,
		markers: [Marker]
	) {
		self.id = id
		self.radius = radius
		self.markers = markers
	}

}

extension Cluster: IMapObject {
	func createJSCode() -> String {
		let markers = self.markers.map { $0.jsCode() }.joined(separator: ",")
		return """
		window.addCluster("\(self.id)", \(self.radius), [\(markers)]);
		"""
	}
}

protocol ClusterDelegate: AnyObject {
}
