import Foundation
import CoreLocation
import WebKit

class JSBridge : NSObject {

	private unowned let executor: JSExecutorProtocol
	weak var delegate: JSBridgeDelegate?

	init(executor: JSExecutorProtocol) {
		self.executor = executor
	}

	func initializeMap(
		center: CLLocationCoordinate2D,
		maxZoom: Double,
		minZoom: Double,
		zoom: Double,
		maxPitch: Double,
		minPitch: Double,
		pitch: Double,
		rotation: Double,
		apiKey: String,
		bundleId: String,
		completion: ((Result<Void, Error>) -> Void)?) {

		let js = """
		window.initializeMap(
		[\(center.longitude), \(center.latitude)],
		\(maxZoom),
		\(minZoom),
		\(zoom),
		\(maxPitch),
		\(minPitch),
		\(pitch),
		\(rotation),
		"\(apiKey)",
		"\(bundleId)");
		"""
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func invalidateSize(completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.invalidateSize();"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func fetchMapCenter(completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?) {
		let js = "window.map.getCenter();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else if let result = result as? [Double], result.count == 2 {
				let lon = result[0]
				let lat = result[1]
				completion?(Result.success(CLLocationCoordinate2D(latitude: lat, longitude: lon)))
			} else {
				completion?(Result.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapCenter(_ center: CLLocationCoordinate2D, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setCenter([\(center.longitude), \(center.latitude)]);"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func fetchMapZoom(completion: ((Result<Double, Error>) -> Void)?) {
		let js = "window.map.getZoom();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else if let result = result as? Double {
				completion?(Result.success(result))
			} else {
				completion?(Result.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapZoom(_ zoom: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setZoom(\(zoom));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func setMapMaxZoom(_ maxZoom: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMaxZoom(\(maxZoom));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func setMapMinZoom(_ minZoom: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMinZoom(\(minZoom));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func fetchMapRotation(completion: ((Result<Double, Error>) -> Void)?) {
		let js = "window.map.getRotation();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else if let result = result as? Double {
				completion?(Result.success(result))
			} else {
				completion?(Result.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapRotation(_ rotation: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setRotation(\(rotation));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func fetchMapPitch(completion: ((Result<Double, Error>) -> Void)?) {
		let js = "window.map.getPitch();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else if let result = result as? Double {
				completion?(Result.success(result))
			} else {
				completion?(Result.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapPitch(_ pitch: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setPitch(\(pitch));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func setMapMaxPitch(_ maxPitch: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMaxPitch(\(maxPitch));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func setMapMinPitch(_ minPitch: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMinPitch(\(minPitch));"
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func addMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js: String
		if let image = marker.image, let imageData = image.pngData() {
			let imageString = imageData.base64EncodedString()
			let markerImage = "data:image/png;base64,\(imageString)"
			js = """
			window.addMarker(
			[\(marker.coordinates.longitude), \(marker.coordinates.latitude)],
			[\(image.size.width), \(image.size.height)],
			"\(markerImage)",
			\(marker.anchor.stringify(with: image)),
			"\(marker.id)");
			"""
		} else {
			js = """
			window.addMarker(
			[\(marker.coordinates.longitude), \(marker.coordinates.latitude)],
			undefined,
			undefined,
			undefined,
			"\(marker.id)");
			"""
		}
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func destroyMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.destroyMarker("\(marker.id)");
		"""
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func hideMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.hideMarker("\(marker.id)");
		"""
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func showMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.showMarker("\(marker.id)");
		"""
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}

	func setMarkerCoordinates(_ marker: Marker, coordinates: CLLocationCoordinate2D, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.setMarkerCoordinates(
		"\(marker.id)",
		[\(marker.coordinates.longitude), \(marker.coordinates.latitude)]);
		"""
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(Result.failure(error))
			} else {
				completion?(Result.success(()))
			}
		}
	}
}

extension JSBridge: WKScriptMessageHandler {

	var messageHandlerName: String {
		return "dgsMessage"
	}

	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard let delegate = self.delegate else { return }
		guard let body = message.body as? Dictionary<String, Any> else { return }
		guard let type = body["type"] as? String else { return }
		switch type {
		case "centerChanged":
			let data = body["value"] as? [Double]
			if let lat = data?.last, let lon = data?.first {
				delegate.js(self, mapCenterDidChange: CLLocationCoordinate2D(latitude: lat, longitude: lon))
			}
		case "zoomChanged":
			let data = body["value"] as? Double
			if let zoom = data {
				delegate.js(self, mapZoomDidChange: zoom)
			}
		case "rotationChanged":
			let data = body["value"] as? Double
			if let rotation = data {
				delegate.js(self, mapRotationDidChange: rotation)
			}
		case "pitchChanged":
			let data = body["value"] as? Double
			if let pitch = data {
				delegate.js(self, mapPitchDidChange: pitch)
			}
		case "mapClick":
			let data = body["value"] as? [Double]
			if let lat = data?.last, let lon = data?.first {
				delegate.js(self, didClickMapWithLocation: CLLocationCoordinate2D(latitude: lat, longitude: lon))
			}
		case "markerClick":
			let data = body["value"] as? String
			if let id = data {
				delegate.js(self, didClickMarkerWithId: id)
			}
		default:
			break
		}
	}
}

private extension Marker.Anchor {

	func stringify(with markerImage: UIImage) -> String {

		let width = Double(markerImage.size.width)
		let height = Double(markerImage.size.height)

		switch self {
		case .bottom:
			return "[\(0.5 * width), \(height)]"
		case .center:
			return "[\(0.5 * width), \(0.5 * height)]"
		case .left:
			return "[0, \(0.5 * height)]"
		case .leftBotton:
			return "[0, \(height)]"
		case .leftTop:
			return "[0, 0]"
		case .right:
			return "[\(width), \(0.5 * height)]"
		case .rightBottom:
			return "[\(width), \(height)]"
		case .rightTop:
			return "[\(width), 0]"
		case .top:
			return "[\(0.5 * width), 0]"
		case .relative(let x, let y):
			return "[\(x * width), \(y * height)]"
		case .absolute(let x, let y):
			return "[\(x), \(y)]"

		}
	}
}
