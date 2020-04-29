import Foundation
import CoreLocation
import WebKit

class JSBridge : NSObject {

	typealias Completion = (Result<Void, Error>) -> Void

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
		completion: Completion? = nil
	) {
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

	func invalidateSize(completion: Completion? = nil) {
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

	func setMapCenter(_ center: CLLocationCoordinate2D, completion: Completion? = nil) {
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

	func setMapZoom(_ zoom: Double, completion: Completion? = nil) {
		let js = "window.map.setZoom(\(zoom));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMaxZoom(_ maxZoom: Double, completion: Completion? = nil) {
		let js = "window.map.setMaxZoom(\(maxZoom));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMinZoom(_ minZoom: Double, completion: Completion? = nil) {
		let js = "window.map.setMinZoom(\(minZoom));"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapRotation(completion: ((Result<Double, Error>) -> Void)? = nil) {
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

	func setMapRotation(_ rotation: Double, completion: Completion? = nil) {
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

	func setMapPitch(_ pitch: Double, completion: Completion? = nil) {
		let js = "window.map.setPitch(\(pitch));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMaxPitch(_ maxPitch: Double, completion: Completion? = nil) {
		let js = "window.map.setMaxPitch(\(maxPitch));"
		self.evaluateJS(js, completion: completion)
	}

	func setMapMinPitch(_ minPitch: Double, completion: Completion? = nil) {
		let js = "window.map.setMinPitch(\(minPitch));"
		self.evaluateJS(js, completion: completion)
	}

	func add(_ object: IMapObject, completion: Completion? = nil) {
		let js = object.createJSCode()
		self.evaluateJS(js, completion: completion)
	}

	func destroy(_ object: IMapObject, completion: Completion? = nil) {
		let js = object.destroyJSCode()
		self.evaluateJS(js, completion: completion)
	}

	func hideMarker(_ marker: Marker, completion: Completion? = nil) {
		let js = """
		window.hideMarker("\(marker.id)");
		"""
		self.evaluateJS(js, completion: completion)
	}

	func showMarker(_ marker: Marker, completion: Completion? = nil) {
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

	private func evaluateJS(_ js: String, completion: Completion? = nil) {
		self.executor.evaluateJavaScript(js) { (_, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else {
				completion?(.success(()))
			}
		}
	}

}

extension JSBridge: WKScriptMessageHandler {

	var messageHandlerName: String { "dgsMessage" }
	var errorHandlerName: String { "error" }

	func userContentController(
		_ userContentController: WKUserContentController,
		didReceive message: WKScriptMessage
	) {
		switch message.name {
			case self.errorHandlerName:
				self.handleError(message: message)
			case self.messageHandlerName:
				self.handleMessage(message: message)
			default:
				break
		}
	}

	private func handleError(message: WKScriptMessage) {
	}

	private func handleMessage(message: WKScriptMessage) {
		guard let delegate = self.delegate else { return }
		guard let body = message.body as? [String: Any] else { return }
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
