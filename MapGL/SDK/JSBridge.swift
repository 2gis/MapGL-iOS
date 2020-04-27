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
		self.evaluateJS(js, completion: completion)
	}

	func invalidateSize(completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.invalidateSize();"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapCenter(completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?) {
		let js = "window.map.getCenter();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else if let result = result as? [Double], result.count == 2 {
				let lon = result[0]
				let lat = result[1]
				completion?(.success(CLLocationCoordinate2D(latitude: lat, longitude: lon)))
			} else {
				completion?(.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapCenter(_ center: CLLocationCoordinate2D, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setCenter([\(center.longitude), \(center.latitude)]);"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapZoom(completion: ((Result<Double, Error>) -> Void)?) {
		let js = "window.map.getZoom();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else if let result = result as? Double {
				completion?(.success(result))
			} else {
				completion?(.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapZoom(_ zoom: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setZoom(\(zoom));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMaxZoom(_ maxZoom: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMaxZoom(\(maxZoom));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMinZoom(_ minZoom: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMinZoom(\(minZoom));"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapRotation(completion: ((Result<Double, Error>) -> Void)?) {
		let js = "window.map.getRotation();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else if let result = result as? Double {
				completion?(.success(result))
			} else {
				completion?(.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapRotation(_ rotation: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setRotation(\(rotation));"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapPitch(completion: ((Result<Double, Error>) -> Void)?) {
		let js = "window.map.getPitch();"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else if let result = result as? Double {
				completion?(.success(result))
			} else {
				completion?(.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func setMapPitch(_ pitch: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setPitch(\(pitch));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMaxPitch(_ maxPitch: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMaxPitch(\(maxPitch));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMinPitch(_ minPitch: Double, completion: ((Result<Void, Error>) -> Void)?) {
		let js = "window.map.setMinPitch(\(minPitch));"
		self.evaluateJS(js, completion: completion)
	}

	func addPolygon(_ polygon: Polygon, completion: ((Result<Void, Error>) -> Void)?) {
		let points = polygon.points.map {
			"[\($0.longitude), \($0.latitude)]"
		}.joined(separator: ",")
		let js = """
		window.addPolygon(
		[[\(points)]],
		"\(polygon.id)",
		\(polygon.strokeWidth.jsValue()),
		\(polygon.fillColor.jsValue()),
		\(polygon.strokeColor.jsValue()),
		\(polygon.z.jsValue()),
		);
		"""
		self.evaluateJS(js, completion: completion)
	}

	func destroyPolygon(_ polygon: Polygon, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.destroyPolygon("\(polygon.id)");
		"""
		self.evaluateJS(js, completion: completion)
	}

	func addCircle(_ circle: Circle, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.addCircle(
		[\(circle.center.longitude), \(circle.center.latitude)],
		"\(circle.radius)",
		"\(circle.id)",
		);
		"""
		self.evaluateJS(js, completion: completion)
	}

	func destroyCircle(_ circle: Circle, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.destroyCircle("\(circle.id)");
		"""
		self.evaluateJS(js, completion: completion)
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
		self.evaluateJS(js, completion: completion)
	}

	func destroyMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.destroyMarker("\(marker.id)");
		"""
		self.evaluateJS(js, completion: completion)
	}

	func hideMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.hideMarker("\(marker.id)");
		"""
		self.evaluateJS(js, completion: completion)
	}

	func showMarker(_ marker: Marker, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.showMarker("\(marker.id)");
		"""
		self.evaluateJS(js, completion: completion)
	}

	func setMarkerCoordinates(_ marker: Marker, coordinates: CLLocationCoordinate2D, completion: ((Result<Void, Error>) -> Void)?) {
		let js = """
		window.setMarkerCoordinates(
		"\(marker.id)",
		[\(marker.coordinates.longitude), \(marker.coordinates.latitude)]);
		"""
		self.evaluateJS(js, completion: completion)
	}

	private func evaluateJS(_ js: String, completion: ((Result<Void, Error>) -> Void)?){
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else {
				completion?(.success(()))
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
