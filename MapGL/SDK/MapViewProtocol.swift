import Foundation
import CoreLocation

protocol MapViewProtocol {

	var centerDidChange: ((CLLocationCoordinate2D) -> Void)? { get set }
	var zoomDidChange: ((Double) -> Void)? { get set }
	var rotationDidChange: ((Double) -> Void)? { get set }
	var pitchDidChange: ((Double) -> Void)? { get set }
	var mapClick: ((CLLocationCoordinate2D) -> Void)? { get set }
	var markerClick: ((Marker) -> Void)? { get set }

	var mapCenter: CLLocationCoordinate2D { get set }
	var mapRotation: Double { get set }
	var mapZoom: Double { get set }
	var mapMinZoom: Double { get set }
	var mapMaxZoom: Double { get set }
	var mapPitch: Double { get set }
	var mapMinPitch: Double { get set }
	var mapMaxPitch: Double { get set }

	func show(
		apiKey: String,
		center: CLLocationCoordinate2D?,
		zoom: Double?,
		rotation: Double?,
		pitch: Double?,
		completion: ((Error?) -> Void)?
	)

	func zoomIn()
	func zoomOut()

	func addMarker(_ marker: Marker)
	func removeMarker(_ marker: Marker)
	func removeAllMarkers()
}
