import Foundation
import CoreLocation
import UIKit

/// Represents a single marker on the map.
open class Marker: MapObject {

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

	/// Gets the marker image.
	public let image: UIImage?

	/// Gets the marker anchor.
	public let anchor: Anchor

	/// Defines the draw order of the marker.
	public let zIndex: CGFloat?

	/// Gets or sets the marker coordinates.
	public var coordinates: CLLocationCoordinate2D {
		didSet {
			if oldValue != self.coordinates {
				self.setMarkerCoordinates(coordinates: self.coordinates)
			}
		}
	}

	/// Marker label
	public let label: Label?

	/// Gets or sets the value indicating whether the marker is hidden.
	public var isHidden: Bool = false {
		didSet {
			if oldValue != self.isHidden {
				if self.isHidden {
					self.hide()
				} else {
					self.show()
				}
			}
		}
	}

	/// Creates the new instance of the marker object.
	///
	/// - Parameters:
	///   - id: Marker uid
	///   - coordinates: Marker geographical coordinates
	///   - image: Marker image
	///   - anchor: Marker anchor
	///   - label: Initialization options of the marker's label. coordinate is ignored
	///   - zIndex: Draw order.
	public init(
		id: String = NSUUID().uuidString,
		coordinates: CLLocationCoordinate2D,
		image: UIImage? = nil,
		anchor: Anchor = .center,
		label: Label? = nil,
		zIndex: CGFloat? = nil
	) {
		self.coordinates = coordinates
		self.image = image
		self.anchor = anchor
		self.label = label
		self.zIndex = zIndex
		super.init(id: id)
	}

}

extension Marker: IHideable {}

extension Marker: IJSOptions {

	struct AnchoredImage: IJSValue {
		let image: UIImage
		let anchor: Marker.Anchor
		func jsValue() -> String {
			self.anchor.stringify(with: self.image)
		}
	}

	func jsKeyValue() -> JSOptionsDictionary {
		var options: JSOptionsDictionary = [
			"id": self.id,
			"coordinates": self.coordinates,
		]
		if let image = self.image {
			options["icon"] = image
			options["size"] = image.size
			options["anchor"] = AnchoredImage(image: image, anchor: self.anchor)
		}
		if let zIndex = self.zIndex {
			options["zIndex"] = zIndex
		}
		if let label = self.label {
			options["label"] = label
		}
		return options
	}

	override func createJSCode() -> String {
		let js = """
		window.addMarker(\(self.jsValue()));
		"""
		return js
	}

	func setMarkerCoordinates(coordinates: CLLocationCoordinate2D) {
		let js = """
		window.setMarkerCoordinates(
		"\(self.id)",
		\(self.coordinates.jsValue())
		);
		"""
		self.evaluateJS(js)
	}

}
