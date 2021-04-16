import Foundation
import UIKit

/// Padding in pixels from the different sides of the map canvas.
public struct Padding {

	public let left: CGFloat
	public let top: CGFloat
	public let right: CGFloat
	public let bottom: CGFloat

	init(
		left: CGFloat = 0.0,
		top: CGFloat = 0.0,
		right: CGFloat = 0.0,
		bottom: CGFloat = 0.0
	) {
		self.left = left
		self.top = top
		self.right = right
		self.bottom = bottom
	}

	public init(insets: UIEdgeInsets) {
		self.left = insets.left
		self.top = insets.top
		self.right = insets.right
		self.bottom = insets.bottom
	}
}

extension Padding: IJSOptions {
	func jsKeyValue() -> JSOptionsDictionary {
		return [
			"bottom": self.bottom,
			"left": self.left,
			"right": self.right,
			"top": self.top,
		]
	}
}
