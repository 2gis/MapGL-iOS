import UIKit.UIImage

extension Marker.Anchor {

	func stringify(with markerImage: UIImage) -> String {

		let width = Double(markerImage.size.width)
		let height = Double(markerImage.size.height)

		switch self {
			case .bottom:
				return "[\(0.5 * width),\(height)]"
			case .center:
				return "[\(0.5 * width),\(0.5 * height)]"
			case .left:
				return "[0,\(0.5 * height)]"
			case .leftBotton:
				return "[0,\(height)]"
			case .leftTop:
				return "[0,0]"
			case .right:
				return "[\(width),\(0.5 * height)]"
			case .rightBottom:
				return "[\(width),\(height)]"
			case .rightTop:
				return "[\(width),0]"
			case .top:
				return "[\(0.5 * width),0]"
			case .relative(let x, let y):
				return "[\(x * width),\(y * height)]"
			case .absolute(let x, let y):
				return "[\(x),\(y)]"

		}
	}
}
