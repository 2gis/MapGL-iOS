import Foundation

/// Padding in points from the different sides of the map canvas.
public struct Padding {
	public let bottom: CGFloat
	public let left: CGFloat
	public let right: CGFloat
	public let top: CGFloat

	public init(bottom: CGFloat = 0.0, left: CGFloat = 0.0, right: CGFloat = 0.0, top: CGFloat = 0.0) {
		self.bottom = bottom
		self.left = left
		self.right = right
		self.top = top
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
