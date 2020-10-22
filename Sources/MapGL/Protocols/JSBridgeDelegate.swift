import Foundation
import CoreLocation

protocol JSBridgeDelegate : AnyObject {

	func js(_ js: JSBridge, mapCenterDidChange mapCenter: CLLocationCoordinate2D)
	func js(_ js: JSBridge, mapZoomDidChange mapZoom: Double)
	func js(_ js: JSBridge, mapRotationDidChange mapRotation: Double)
	func js(_ js: JSBridge, mapPitchDidChange mapRotation: Double)
	func js(_ js: JSBridge, didClickMapWithEvent event: MapClickEvent)
	func js(_ js: JSBridge, didClickObjectWithId objectId: String)
	func js(_ js: JSBridge, didClickClusterWithId clusterId: String, markerIds: [String])
	func js(_ js: JSBridge, carRouteDidFinishWithId directionId: String, completionId: String, error: MapGLError?)

}
