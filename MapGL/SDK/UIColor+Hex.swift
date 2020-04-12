import UIKit

extension UIColor {

	func hex() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0

		getRed(&r, green: &g, blue: &b, alpha: &a)

		let rgba: Int =
			(Int)(r * 255) << 32 |
			(Int)(g * 255) << 16 |
			(Int)(b * 255) << 8 |
			(Int)(a * 255) << 0
		return String(format: "#%08x", rgba)
	}
}
