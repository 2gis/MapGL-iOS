import UIKit

extension UIView {

	var safeArea: UIEdgeInsets {
		if #available(iOS 11.0, *) {
			return self.safeAreaInsets
		} else {
			return UIEdgeInsets.zero
		}
	}

	var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
		if #available(iOS 11.0, *) {
			return self.safeAreaLayoutGuide.leadingAnchor
		} else {
			return self.leadingAnchor
		}
	}

	var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
		if #available(iOS 11.0, *) {
			return self.safeAreaLayoutGuide.trailingAnchor
		} else {
			return self.trailingAnchor
		}
	}

	var safeAreaTopAnchor: NSLayoutYAxisAnchor {
		if #available(iOS 11.0, *) {
			return self.safeAreaLayoutGuide.topAnchor
		} else {
			return self.topAnchor
		}
	}

	var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
		if #available(iOS 11.0, *) {
			return self.safeAreaLayoutGuide.bottomAnchor
		} else {
			return self.bottomAnchor
		}
	}
}
