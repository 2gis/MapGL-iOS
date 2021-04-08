import Foundation

/// Options for Map.fitBounds.
public struct FitBoundsOptions {
	/// If `true` the method `fitBounds` will consider map rotation.
	public let considerRotation: Bool

	/// The amount of padding in pixels to add to the given bounds.
	public let padding: Padding?

	public init(considerRotation: Bool = false, padding: Padding? = nil) {
		self.considerRotation = considerRotation
		self.padding = padding
	}
}

extension FitBoundsOptions: IJSOptions {
	func jsKeyValue() -> JSOptionsDictionary {
		return [
			"considerRotation": self.considerRotation,
			"padding": self.padding,
		]
	}
}
