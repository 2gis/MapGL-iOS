import CoreLocation
import UIKit.UIColor

/// Circle object on map
open class Circle: MapObject {

	let center: CLLocationCoordinate2D
	let radius: CLLocationDistance
	let strokeColor: UIColor?
	let fillColor: UIColor?
	let strokeWidth: CGFloat?
	let z: Int?

	/// Creates new circle on map
	/// - Parameters:
	///   - id: Unique object id
	///   - center: Position on map
	///   - radius: Radius in meters
	///   - strokeColor: Stroke color of circle
	///   - strokeWidth: Stroke width of circle
	///   - fillColor: Circle fill color
	///   - z: Draw order
	public init(
		id: String = UUID().uuidString,
		center: CLLocationCoordinate2D,
		radius: CLLocationDistance,
		strokeColor: UIColor? = nil,
		strokeWidth: CGFloat? = nil,
		fillColor: UIColor? = nil,
		z: Int? = nil
	) {
		self.center = center
		self.radius = radius
		self.strokeColor = strokeColor
		self.strokeWidth = strokeWidth
		self.fillColor = fillColor
		self.z = z
		super.init(id: id)
	}

}

extension Circle: IJSValue {

	func jsValue() -> String {
		return """
		{
		id: "\(self.id)",
		coordinates: \(self.center.jsValue()),
		radius: \(self.radius),
		color: \(self.fillColor.jsValue()),
		strokeWidth: \(self.strokeWidth.jsValue()),
		strokeColor: \(self.strokeColor.jsValue()),
		zIndex: \(self.z.jsValue()),
		}
		"""
	}

	override func createJSCode() -> String {
		let js = """
		window.addCircle(\(self.jsValue()));
		"""
		return js
	}

}
