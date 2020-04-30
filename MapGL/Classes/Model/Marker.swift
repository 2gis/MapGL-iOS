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

	/// Gets or sets the marker coordinates.
	public var coordinates: CLLocationCoordinate2D {
		didSet {
			if oldValue != self.coordinates {
				self.setMarkerCoordinates(coordinates: self.coordinates)
			}
		}
	}

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
	///   - coordinates: Marker geographical coordinates
	///   - image: Marker image
	///   - anchor: Marker anchor
	///   - uid: Marker uid
	public init(
		id: String = NSUUID().uuidString,
		coordinates: CLLocationCoordinate2D,
		image: UIImage? = nil,
		anchor: Anchor = .center
	) {
		self.coordinates = coordinates
		self.image = image
		self.anchor = anchor
		super.init(id: id)
	}

}

extension Marker {

	func jsCode() -> String {
		let js: String
		if let image = self.image, let imageData = image.pngData() {
			let imageString = imageData.base64EncodedString()
			let markerImage = "data:image/png;base64,\(imageString)"
			js = """
			{
			id: "\(self.id)",
			coordinates: \(self.coordinates.toJS()),
			icon: "\(markerImage)",
			anchor: \(self.anchor.stringify(with: image)),
			size: [\(image.size.width), \(image.size.height)],
			}
			"""
		} else {
			js = """
			{
			id: "\(self.id)",
			coordinates: \(self.coordinates.toJS()),
			icon: undefined,
			anchor: undefined,
			size: undefined,
			}
			"""
		}
		return js
	}

	override func createJSCode() -> String {
		let js = """
		window.addMarker(\(self.jsCode()));
		"""
		return js
	}

	private func hide() {
		let js = """
		window.hideMarker("\(self.id)");
		"""
		self.delegate?.evaluateJS(js)
	}

	private func show() {
		let js = """
		window.showMarker("\(self.id)");
		"""
		self.delegate?.evaluateJS(js)
	}

	func setMarkerCoordinates(coordinates: CLLocationCoordinate2D) {
		let js = """
		window.setMarkerCoordinates(
		"\(self.id)",
		\(self.coordinates.toJS())
		);
		"""
		self.delegate?.evaluateJS(js)
	}

}
