/// Common options for map animations. Used by methods such as setCenter, setZoom, etc.
public struct AnimationOptions {

	/// Determines if the transform should be animated.
	let animate: Bool

	/// Duration of the animation
	let duration: TimeInterval

	/// Easing function to be used with the animation.
	let easing: Easing

	public init(
		animate: Bool = true,
		duration: TimeInterval = 0.5,
		easing: Easing = .linear
	) {
		self.animate = animate
		self.duration = duration
		self.easing = easing
	}

}

extension AnimationOptions: IJSOptions {
	func jsKeyValue() -> [String : IJSValue] {
		return [
			"animate": self.animate.jsValue(),
			"duration": (self.duration * 1000).jsValue(),
			"easing": self.easing.rawValue,
		]
	}
}
