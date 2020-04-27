import Foundation
import CoreLocation

protocol JSBridgeDelegate : class {

	func js(_ js: JSBridge, mapCenterDidChange mapCenter: CLLocationCoordinate2D)
	func js(_ js: JSBridge, mapZoomDidChange mapZoom: Double)
	func js(_ js: JSBridge, mapRotationDidChange mapRotation: Double)
	func js(_ js: JSBridge, mapPitchDidChange mapRotation: Double)
	func js(_ js: JSBridge, didClickMapWithLocation location: CLLocationCoordinate2D)
	func js(_ js: JSBridge, didClickMarkerWithId makerId: String)

}
