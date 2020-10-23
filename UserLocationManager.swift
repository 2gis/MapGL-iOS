import Foundation
import CoreLocation

/// Options for location services.
public struct UserLocationOptions {

	/// Gets the desired location accuracy.
	public let desiredAccuracy: CLLocationAccuracy

	/// Creates the instance of UserLocationOptions struct.
	/// - Parameter desiredAccuracy: Desired location accuracy.
	public init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
		self.desiredAccuracy = desiredAccuracy
	}

}

// MARK: - UserLocationManager

class UserLocationManager: NSObject {

	private let locationManager = CLLocationManager()
	private var locationMarker: CircleMarker?
	weak var map: MapView?

	var userLocation: CLLocation? {
		return locationManager.location
	}

	override init() {
		super.init()
		locationManager.delegate = self
	}

	func enableUserLocation(options: UserLocationOptions) {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestWhenInUseAuthorization()
			locationManager.desiredAccuracy = options.desiredAccuracy
			locationManager.startUpdatingLocation()
		}
	}

	func disableUserLocation() {
		locationManager.stopUpdatingLocation()
		removeLocationMarker()
	}

}

// MARK: - CLLocationManagerDelegate

extension UserLocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		removeLocationMarker()
		if let location = manager.location {
			addLocationMarker(location: location)
		}
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			break
		case .denied, .notDetermined, .restricted:
			self.removeLocationMarker()
		@unknown default:
			self.removeLocationMarker()
		}
	}

	private func addLocationMarker(location: CLLocation) {
		let marker = CircleMarker(coordinates: location.coordinate)
		self.map?.addUserLocationMarker(marker)
		self.locationMarker = marker
	}

	private func removeLocationMarker() {
		if let marker = self.locationMarker {
			self.map?.remove(marker)
			self.locationMarker = nil
		}
	}
}
