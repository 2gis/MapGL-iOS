import CoreLocation
import UIKit.UIColor

open class Circle: MapObject {

	public let center: CLLocationCoordinate2D
	public let radius: CLLocationDistance
	let strokeColor: UIColor?
	let fillColor: UIColor?
	let strokeWidth: CGFloat?
	let z: Int?

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

extension Circle {

	func jsCode() -> String {
		return """
		{
		id: "\(self.id)",
		coordinates: \(self.center.toJS()),
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
		window.addCircle(\(self.jsCode()));
		"""
		return js
	}

}
