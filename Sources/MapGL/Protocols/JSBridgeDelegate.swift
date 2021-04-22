import Foundation
import CoreLocation

protocol JSBridgeDelegate : AnyObject {

	func js(_ js: JSBridge, mapCenterDidChange mapCenter: CLLocationCoordinate2D)
	func js(_ js: JSBridge, mapZoomDidChange mapZoom: Double)
	func js(_ js: JSBridge, mapStyleZoomChanged mapZoom: Double)
	func js(_ js: JSBridge, mapRotationDidChange mapRotation: Double)
	func js(_ js: JSBridge, mapPitchDidChange mapRotation: Double)
	func js(_ js: JSBridge, didClickMapWithEvent event: MapClickEvent)
	func js(_ js: JSBridge, didClickObjectWithId objectId: String)
	func js(_ js: JSBridge, didClickClusterWithId clusterId: String, markerIds: [String])
	func js(_ js: JSBridge, carRouteDidFinishWithId directionId: String, completionId: String, error: MapGLError?)
	func js(_ js: JSBridge, showFloorPlan floorPlanId: String, currentLevelIndex: Int, floorLevels: [String])
	func js(_ js: JSBridge, hideFloorPlan floorPlanId: String)
	func js(_ js: JSBridge, supportedReason notSupportedReason: String?, notSupportedWithGoodPerformanceReason: String?)

}
