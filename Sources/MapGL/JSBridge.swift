import Foundation
import CoreLocation
import WebKit

private struct JSOptions: IJSOptions {
	let options: JSOptionsDictionary

	func jsKeyValue() -> JSOptionsDictionary {
		self.options
	}
}

class JSBridge : NSObject {

	typealias Completion = (Result<Void, Error>) -> Void

	private unowned let executor: JSExecutorProtocol
	weak var delegate: JSBridgeDelegate?

	init(executor: JSExecutorProtocol) {
		self.executor = executor
	}

	func initializeMap(
		options: JSOptionsDictionary,
		completion: Completion? = nil
	) {
		let value = JSOptions(options: options)
		let js = "window.initializeMap(\(value.jsValue()));"
		self.evaluateJS(js, completion: completion)
	}

	func invalidateSize(completion: Completion? = nil) {
		let js = "window.map.invalidateSize();"
		self.evaluateJS(js, completion: completion)
	}

	func fetchGeographicalBounds(completion: @escaping (Result<GeographicalBounds, Error>) -> Void) {
		let js = "window.map.getBounds();"
		self.executor.evaluateJavaScript(js) { result, erorr in
			if let error = erorr {
				completion(.failure(error))
			} else {
				let dictionary = result as? [String: Any]
				if let bounds = GeographicalBounds(dictionary: dictionary) {
					completion(.success(bounds))
				} else {
					completion(.failure(MapGLError(text: "Parsing error")))
				}
			}
		}
	}

	func fitBounds(_ bounds: GeographicalBounds, options: FitBoundsOptions? = nil, completion: Completion?) {
		let js = "window.map.fitBounds(\(bounds.jsValue()), \(options.jsValue()));"
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
		let js = "window.map.setCenter(\(center.jsValue()));"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapZoom(completion: ((Result<Double, Error>) -> Void)?) {
		self.fetch(js: "window.map.getZoom();", completion: completion)
	}

	func fetchMapStyleZoom(completion: ((Result<Double, Error>) -> Void)?) {
		self.fetch(js: "window.map.getStyleZoom();", completion: completion)
	}

	func setMapZoom(
		_ zoom: Double,
		options: MapGL.AnimationOptions? = nil,
		completion: Completion? = nil
	) {
		let js = "window.map.setZoom(\(zoom), \(options.jsValue()));"
		self.evaluateJS(js, completion: completion)
	}

	func setStyleZoom(_ zoom: Double, options: MapGL.AnimationOptions? = nil) {
		let js = "window.map.setStyleZoom(\(zoom), \(options.jsValue()));"
		self.evaluateJS(js)
	}

	func setStyle(by id: String, completion: Completion? = nil) {
		let js = #"window.map.setStyleById("\#(id)");"#
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
		self.fetch(js: "window.map.getRotation();", completion: completion)
	}

	func setMapRotation(_ rotation: Double, completion: Completion? = nil) {
		let js = "window.map.setRotation(\(rotation));"
		self.evaluateJS(js, completion: completion)
	}

	func fetchMapPitch(completion: ((Result<Double, Error>) -> Void)?) {
		self.fetch(js: "window.map.getPitch();", completion: completion)
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

	func add(_ object: IJSMapObject, completion: Completion? = nil) {
		let js = object.createJSCode()
		self.evaluateJS(js, completion: completion)
	}

	func destroy(_ object: IJSMapObject, completion: Completion? = nil) {
		let js = object.destroyJSCode()
		self.evaluateJS(js, completion: completion)
	}

	func evaluateJS(_ js: String, completion: Completion? = nil) {
		self.executor.evaluateJavaScript(js) { (_, error) in
			if let error = error {
				// Then js returns the map object itself we have an error:
				// 'JavaScript execution returned a result of an unsupported type'. Ignore it.
				if (error as? WKError)?.code == .javaScriptResultTypeIsUnsupported {
					completion?(.success(()))
				} else {
					completion?(.failure(error))
				}
			} else {
				completion?(.success(()))
			}
		}
	}

	func setSelectedObjects(_ objectsIds: [String]) {
		let js = """
		window.setSelectedObjects(\(objectsIds.jsValue()));
		"""
		self.evaluateJS(js)
	}

	func setStyle(style: String) {
		let js = """
		window.setStyle(\(style.jsValue()));
		"""
		self.evaluateJS(js)
	}

	func setStyleState(styleState: [String: Bool]) {
		let styleState = styleState.mapValues { $0.jsValue() }.jsValue()
		let js = """
		window.setStyleState(\(styleState));
		"""
		self.evaluateJS(js)
	}

	func patchStyleState(styleState: [String: Bool]) {
		let styleState = styleState.mapValues { $0.jsValue() }.jsValue()
		let js = """
		window.patchStyleState(\(styleState));
		"""
		self.evaluateJS(js)
	}

	func setPadding(padding: Padding) {
		let js = """
		window.setPadding(\(padding.jsValue()));
		"""
		self.evaluateJS(js)
	}

	func setFloorPlanLevel(floorPlanId: String, floorLevelIndex: Int) {
		let js = """
		window.setFloorPlanLevel(\(floorPlanId.jsValue()), \(floorLevelIndex));
		"""
		self.evaluateJS(js)
	}

	func project(location: CLLocationCoordinate2D, completion: @escaping (Result<CGPoint, Error>) -> Void) {
		let js = "window.map.project(\(location.jsValue()));"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion(.failure(error))
			} else if let result = result as? [CGFloat], result.count >= 2 {
				let x = result[0]
				let y = result[1]
				completion(.success(CGPoint(x: x, y: y)))
			} else {
				completion(.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	func unproject(point: CGPoint, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
		let js = "window.map.unproject(\(point.jsValue()));"
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion(.failure(error))
			} else if let result = result as? [Double], result.count == 2 {
				let lon = result[0]
				let lat = result[1]
				completion(.success(CLLocationCoordinate2D(latitude: lat, longitude: lon)))
			} else {
				completion(.failure(MapGLError(text: "Parsing error")))
			}
		}
	}

	private func fetch<T>(js: String, completion: ((Result<T, Error>) -> Void)?) {
		self.executor.evaluateJavaScript(js) { (result, erorr) in
			if let error = erorr {
				completion?(.failure(error))
			} else if let result = result as? T {
				completion?(.success(result))
			} else {
				completion?(.failure(MapGLError(text: "Parsing error")))
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
				if let zoom = body["value"] as? Double {
					delegate.js(self, mapZoomDidChange: zoom)
				}
			case "styleZoomChanged":
				if let zoom = body["value"] as? Double {
					delegate.js(self, mapStyleZoomChanged: zoom)
				}
			case "rotationChanged":
				if let rotation = body["value"] as? Double {
					delegate.js(self, mapRotationDidChange: rotation)
				}
			case "pitchChanged":
				if let pitch = body["value"] as? Double {
					delegate.js(self, mapPitchDidChange: pitch)
				}
			case "mapClick":
				if let data = body["value"] as? String, let event = MapClickEvent(string: data) {
					delegate.js(self, didClickMapWithEvent: event)
				}
			case "objectClick":
				if let id = body["value"] as? String {
					delegate.js(self, didClickObjectWithId: id)
				} else {
					assertionFailure()
				}
			case "clusterClick":
				guard let clusterId = body["id"] as? String else { assertionFailure(); return }

				if let marker = body["value"] as? [String: Any] {
					if let id = marker["id"] as? String {
						delegate.js(self, didClickClusterWithId: clusterId, markerIds: [id])
					} else {
						assertionFailure()
					}
				} else if let cluster = body["value"] as? [[String: Any]] {
					let ids = cluster.compactMap { $0["id"] as? String }
					assert(cluster.count == ids.count)
					delegate.js(self, didClickClusterWithId: clusterId, markerIds: ids)
				} else {
					assertionFailure()
				}
			case "carRouteCompletion":
				guard let data = body["value"] as? [String: String],
					  let directionId = data["directionId"],
					  let completionId = data["completionId"],
					  let error = data["error"] else {

					assertionFailure()
					return
				}
				let mapglError: MapGLError? = error.isEmpty ? nil : MapGLError(text: error)
				delegate.js(self, carRouteDidFinishWithId: directionId, completionId: completionId, error: mapglError)
			case "floorPlanShow":
				guard let data = body["value"] as? [String: Any],
					  let id = data["floorPlanId"] as? String,
					  let currentLevelIndex = data["currentFloorLevelIndex"] as? Int,
					  let levelObjects = data["floorLevels"] as? [[String: Any]] else {
					assertionFailure()
					return
				}

				let levels = levelObjects.compactMap({ $0["floorLevelName"] as? String })
				delegate.js(self, showFloorPlan: id, currentLevelIndex: currentLevelIndex, floorLevels: levels)
			case "floorPlanHide":
				guard let data = body["value"] as? [String: Any],
					  let id = data["floorPlanId"] as? String else {
					assertionFailure()
					return
				}

				delegate.js(self, hideFloorPlan: id)
			case "supportChanged":
				let data = body["value"] as? [String: String]
				let notSupportedReason = data?["notSupportedReason"]
				let notSupportedWithGoodPerformanceReason = data?["notSupportedWithGoodPerformanceReason"]
				delegate.js(
					self,
					supportedReason: notSupportedReason,
					notSupportedWithGoodPerformanceReason: notSupportedWithGoodPerformanceReason
				)
			default:
				assertionFailure()
		}
	}

}
