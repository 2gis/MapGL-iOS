import Foundation
import UIKit

/// Options for `map.fitBounds` method
public struct FitBoundsOptions {

	/// Animation options
	let animation: AnimationOptions?

	/// If true the fitBounds will consider the map rotation
	let considerRotation: Bool

	/// The amount of padding in pixels to add to the given bounds
	let padding: Padding

	public init(
		animation: AnimationOptions? = nil,
		considerRotation: Bool = false,
		padding: UIEdgeInsets = .zero
	) {
		self.animation = animation
		self.considerRotation = considerRotation
		self.padding = Padding(insets: padding)
	}
}

extension FitBoundsOptions: IJSOptions {
	func jsKeyValue() -> JSOptionsDictionary {
		return [
			"animation": self.animation,
			"considerRotation": self.considerRotation,
			"padding": self.padding,
		]
	}
}
