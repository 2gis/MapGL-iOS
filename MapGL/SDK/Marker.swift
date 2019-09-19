import Foundation
import CoreLocation
import UIKit

/// Represents a single marker on the map.
public class Marker {

	/// Defines how the marker image is positioned relative to the marker coordinates.
	///
	/// - leftTop: Left top corner of the marker image is positioned on the marker coordinates
	/// - top: Top center point of the marker image is positioned on the marker coordinates
	/// - rightTop: Right top corner of the marker image is positioned on the marker coordinates
	/// - left: Left center point of the marker image is positioned on the marker coordinates
	/// - center: Center point of the marker image is positioned on the marker coordinates
	/// - right: Right center point of the marker image is positioned on the marker coordinates
	/// - leftBotton: Left bottom corner of the marker image is positioned on the marker coordinates
	/// - bottom: Bottom center point of the marker image is positioned on the marker coordinates
	/// - rightBottom: Right bottom corner of the marker image is positioned on the marker coordinates
	/// - absolute: Custom marker image positioning using the absolute pixels
	/// - relative: Custom marker image positioning using the points relative to the marker size,
	/// i.e. (0, 0) is the top left corner of the marker and (1, 1) is the bottom right corner of the marker
	public enum Anchor {
		case leftTop
		case top
		case rightTop
		case left
		case center
		case right
		case leftBotton
		case bottom
		case rightBottom
		case absolute(Double, Double)
		case relative(Double, Double)
	}

	let id: String
	weak var delegate: MarkerDelegate?

	/// Notifies of the marker click event.
	public var click: (() -> Void)?

	/// Gets the marker image.
	public let image: UIImage?

	/// Gets the marker anchor.
	public let anchor: Anchor

	/// Gets or sets the marker coordinates.
	public var coordinates: CLLocationCoordinate2D {
		didSet {
			if oldValue.longitude != self.coordinates.longitude || oldValue.latitude != self.coordinates.latitude {
				self.delegate?.marker(self, didChangeCoordinates: self.coordinates)
			}
		}
	}

	/// Gets or sets the value indicating whether the marker is hidden.
	public var isHidden: Bool = false {
		didSet {
			if oldValue != self.isHidden {
				if self.isHidden {
					self.delegate?.markerDidHide(self)
				} else {
					self.delegate?.markerDidShow(self)
				}
			}
		}
	}

	/// Creates the new instance of the marker object.
	///
	/// - Parameters:
	///   - coordinates: Marker geographical coordinates
	///   - image: Marker image
	///   - anchor: Marker anchor
	public convenience init(coordinates: CLLocationCoordinate2D, image: UIImage, anchor: Anchor) {
		let uid = NSUUID().uuidString
		self.init(coordinates: coordinates, image: image, anchor: anchor, uid: uid)
	}

	/// Creates the new instance of the marker object.
	///
	/// - Parameters:
	///   - coordinates: Marker geographical coordinates
	public convenience init(coordinates: CLLocationCoordinate2D) {
		let uid = NSUUID().uuidString
		self.init(coordinates: coordinates, image: nil, anchor: .center, uid: uid)
	}

	/// Creates the new instance of the marker object.
	///
	/// - Parameters:
	///   - coordinates: Marker geographical coordinates
	///   - image: Marker image
	///   - anchor: Marker anchor
	///   - uid: Marker uid
	init(coordinates: CLLocationCoordinate2D, image: UIImage?, anchor: Anchor, uid: String) {
		self.id = uid
		self.coordinates = coordinates
		self.image = image
		self.anchor = anchor
	}

	/// Removes the marker from the map.
	public func remove() {
		self.delegate?.markerDidRemove(self)
	}
}
