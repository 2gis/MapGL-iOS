import Foundation
import CoreLocation

protocol MarkerDelegate: AnyObject {

	func marker(_ marker: Marker, didChangeCoordinates coordinates: CLLocationCoordinate2D)
	func markerDidHide(_ marker: Marker)
	func markerDidShow(_ marker: Marker)
	func markerDidRemove(_ marker: Marker)

}
