import CoreLocation
import UIKit.UIColor

/// Class for creating labels on the map.
open class Label: MapObject {

	let center: CLLocationCoordinate2D
	let text: String
	let color: UIColor
	let fontSize: CGFloat
	let anchor: CGPoint
	let backgroundImage: LabelImage?
	let relativeAnchor: CGPoint
	let offset: CGPoint

	/// Creates new label on map
	/// - Parameters:
	///   - id: Unique object id
	///   - center: Position on map
	///   - color: Text color
	///   - text: Label text
	///   - fontSize: Label font size
	///   - anchor: The position in pixels of the "tip" of the label relative to its center.
	///   - backgroundImage: Image background for the label
	///   - relativeAnchor: The relative, from 0 to 1 in each dimension, coordinates of the text box "tip".
	///   Relative to its top left corner, for example: [0, 0] value is the top left corner,
	///    [0.5, 0.5] — center point, and [1, 1] is the bottom right corner of the box. The label will be
	///    placed so that this point is at geographical coordinates respects the absolute `offset`.
	///   - offset: The offset distance of text box from its `relativeAnchor`.
	///   Positive values indicate right and down, while negative values indicate left and up.
	public init(
		id: String = UUID().uuidString,
		center: CLLocationCoordinate2D,
		color: UIColor,
		text: String,
		fontSize: CGFloat,
		anchor: CGPoint = .zero,
		backgroundImage: LabelImage? = nil,
		relativeAnchor: CGPoint = CGPoint(x: 0.5, y: 0.5),
		offset: CGPoint = .zero
	) {
		self.center = center
		self.color = color
		self.text = text
		self.fontSize = fontSize
		self.anchor = anchor
		self.backgroundImage = backgroundImage
		self.relativeAnchor = relativeAnchor
		self.offset = offset
		super.init(id: id)
	}

}

/// Label background image
public class LabelImage {

	/// Background image
	public let image: UIImage
	/// space in pixels between the label text box and the edge of the stretched image
	public let padding: UIEdgeInsets

	/// Source image for text label background.
	/// - Parameters:
	///   - image: Background image
	///   - padding: Sets the space in pixels between the label text box and the edge of the stretched image for all four sides
	public init(
		image: UIImage,
		padding: UIEdgeInsets = .zero
	) {
		self.image = image
		self.padding = padding
	}
}

extension LabelImage: IJSOptions {

	struct Range: IJSValue {
		let from: CGFloat
		let to: CGFloat

		func jsValue() -> String { "[[\(self.from),\(self.to)]]" }
	}

	func jsKeyValue() -> [String : IJSValue] {
		let insets = self.image.capInsets
		let size = self.image.size
		return [
			"padding": self.padding,
			"size": size,
			"url": self.image,
			"stretchX": Range(from: insets.left, to: size.width - insets.right),
			"stretchY": Range(from: insets.top, to: size.height - insets.bottom),
		]
	}

}

extension Label: IHideable {}

extension Label: IJSOptions {

	func jsKeyValue() -> [String : IJSValue] {
		[
			"id": self.id,
			"coordinates": self.center,
			"text": self.text,
			"color": self.color,
			"fontSize": self.fontSize,
			"image": self.backgroundImage,
			"anchor": self.anchor,
			"relativeAnchor": self.relativeAnchor,
			"offset": self.offset,
		]
	}

	override func createJSCode() -> String {
		let js = """
		window.addLabel(\(self.jsValue()));
		"""
		return js
	}

}
