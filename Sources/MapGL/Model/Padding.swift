import Foundation
import UIKit

/// Padding in pixels from the different sides of the map canvas.
struct Padding {

    let left: CGFloat
    let top: CGFloat
    let right: CGFloat
    let bottom: CGFloat

    init(
        left: CGFloat,
        top: CGFloat,
        right: CGFloat,
        bottom: CGFloat
    ) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }

    init(insets: UIEdgeInsets) {
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
