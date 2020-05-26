import CoreLocation
import UIKit.UIColor

open class Polygon: MapObject {

	/// Geographical coordinates of polygon points
	public let points: [CLLocationCoordinate2D]
	let strokeColor: UIColor?
	let fillColor: UIColor?
	let strokeWidth: CGFloat?
	let z: Int?

	/// Creates new polygon on map
	/// - Parameters:
	///   - id: Unique object id
	///   - points: Geographical coordinates of polygon points
	///   - strokeColor: Stroke color
	///   - strokeWidth: Stroke width in screen points.
	///   - fillColor: Fill color
	///   - z: Draw order.
	public init(
		id: String = UUID().uuidString,
		points: [CLLocationCoordinate2D],
		strokeColor: UIColor? = nil,
		strokeWidth: CGFloat? = nil,
		fillColor: UIColor? = nil,
		z: Int? = nil
	) {
		assert(points.count > 2, "Polygon should countain more than 2 points")
		self.points = points
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		self.strokeWidth = strokeWidth
		self.z = z
		super.init(id: id)
	}

}

extension Polygon: IJSValue {

	func jsValue() -> String {
		var polygonPoints = self.points
		// Polygon should end with same point as starts
		if !polygonPoints.isEmpty, polygonPoints.first != polygonPoints.last {
			polygonPoints.append(polygonPoints[0])
		}
		let points = polygonPoints.jsValue()
		return """
		{
			id: "\(self.id)",
			coordinates: [\(points)],
			strokeWidth: \(self.strokeWidth.jsValue()),
			color: \(self.fillColor.jsValue()),
			strokeColor: \(self.strokeColor.jsValue()),
			zIndex: \(self.z.jsValue()),
		}
		"""
	}

	override func createJSCode() -> String {
		let js = """
		window.addPolygon(\(self.jsValue()));
		"""
		return js
	}

}
