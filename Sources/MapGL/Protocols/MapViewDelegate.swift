import CoreLocation

/// Optional methods that you use to receive map-related update messages.
@objc public protocol MapViewDelegate: AnyObject {

	/// Notifies when user select any object
	/// - Parameters:
	///   - mapView: Map view
	///   - object: instance of map object (marker, circle, polygon, building, etc)
	@objc optional func mapView(_ mapView: MapView, didSelectObject object: MapObject)

	/// Notifies when user select one or many markers in cluster
	/// - Parameters:
	///   - mapView: Map view
	///   - markers: list of markers in group
	///   - cluster: cluster in which markers are belong
	@objc optional func mapView(_ mapView: MapView, didSelectMarkers markers: [Marker], in cluster: Cluster)

	/// Notifies of the map click event.
	/// - Parameters:
	///   - mapView: Map view
	///   - coordnates: coordnates of click event
	@objc optional func mapView(_ mapView: MapView, didSelectCoordnates coordnates: CLLocationCoordinate2D)

	/// Notifies of the user location update.
	/// - Parameters:
	///   - mapView: Map view
	///   - location: User location
	@objc optional func mapView(_ mapView: MapView, didUpdateUserLocation location: CLLocation?)

}
