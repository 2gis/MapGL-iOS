import UIKit
import WebKit
import CoreLocation

public class MapView : UIView {

	struct Const {
		static let mapMinZoom: Double = 2
		static let mapMaxZoom: Double = 20
		static let mapMinPitch: Double = 0
		static let mapMaxPitch: Double = 60

		static let mapDefaultZoom: Double = 2
		static let mapDefaultRotation: Double = 0
		static let mapDefaultPitch: Double = 0
		static let mapDefaultMinZoom: Double = 2
		static let mapDefaultMaxZoom: Double = 20
		static let mapDefaultMinPitch: Double = 0
		static let mapDefaultMaxPitch: Double = 45
		static let mapDefaultCenter = CLLocationCoordinate2D(latitude: 55.750574, longitude: 37.618317)
	}

	private var markers: [String: Marker] = [:]
	private var polygons: [String: Polygon] = [:]
	private var circles: [String: Circle] = [:]
	private var polylines: [String: Polyline] = [:]
	private var jsExecutor: JSExecutorProtocol?
	private var initializeMap: (() -> Void)?

	private var _mapCenter = Const.mapDefaultCenter
	private var _mapRotation: Double = Const.mapDefaultRotation

	private var _mapZoom: Double = Const.mapDefaultZoom
	private var _mapMinZoom: Double = Const.mapDefaultMinZoom
	private var _mapMaxZoom: Double = Const.mapDefaultMaxZoom

	private var _mapPitch: Double = Const.mapDefaultPitch
	private var _mapMinPitch: Double = Const.mapDefaultMinPitch
	private var _mapMaxPitch: Double = Const.mapDefaultMaxPitch

	private lazy var js: JSBridge = {
		let js = JSBridge(executor: self.jsExecutor ?? self)
		js.delegate = self
		return js
	}()

	private lazy var webView: WKWebView = {
		let webConfiguration = WKWebViewConfiguration()
		webConfiguration.userContentController.add(self.js, name: self.js.messageHandlerName)
		webConfiguration.userContentController.add(self.js, name: self.js.errorHandlerName)
		let webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.navigationDelegate = self
		return webView
	}()

	/// Notifies of the map geographical center change.
	public var centerDidChange: ((CLLocationCoordinate2D) -> Void)?
	/// Notifies of the map zoom level change.
	public var zoomDidChange: ((Double) -> Void)?
	/// Notifies of the map rotation angle change.
	public var rotationDidChange: ((Double) -> Void)?
	/// Notifies of the map pitch angle change.
	public var pitchDidChange: ((Double) -> Void)?
	/// Notifies of the map click event.
	public var mapClick: ((CLLocationCoordinate2D) -> Void)?
	/// Notifies of the marker click event.
	public var markerClick: ((Marker) -> Void)?

	/// Creates the new instance of the MapView object.
	///
	/// - Parameter jsExecutor: Custom JS executor
	init(jsExecutor: JSExecutorProtocol) {
		super.init(frame: .zero)
		self.jsExecutor = jsExecutor
		self.commonInit()
	}

	/// Creates the new instance of the MapView object.
	///
	/// - Parameter frame: Initial view frame
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}

	/// Creates the new instance of the MapView object.
	///
	/// - Parameter aDecoder: NSCoder instance
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.commonInit()
	}

	private func commonInit() {
		if #available(iOS 11.0, *) {
			self.webView.scrollView.contentInsetAdjustmentBehavior = .never
		}
		self.addSubview(self.webView)
	}

	/// Lays out subviews.
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.webView.frame = self.bounds
	}
}

extension MapView : MapViewProtocol {

	/// Gets or sets the geographical center of the map.
	public var mapCenter: CLLocationCoordinate2D {
		get {
			return _mapCenter
		}
		set {
			_mapCenter = newValue
			self.js.setMapCenter(newValue, completion: nil)
		}
	}

	/// Gets or sets the rotation angle of the map.
	public var mapRotation: Double {
		get {
			return _mapRotation
		}
		set {
			_mapRotation = newValue
			self.js.setMapRotation(newValue, completion: nil)
		}
	}

	/// Gets or sets the zoom level of the map.
	public var mapZoom: Double {
		get {
			return _mapZoom
		}
		set {
			_mapZoom = max(newValue, _mapMinZoom)
			_mapZoom = min(_mapZoom, _mapMaxZoom)
			self.js.setMapZoom(_mapZoom, completion: nil)
		}
	}

	/// Gets or sets the mininal zoom level of the map. This value can not be less than 2.
	public var mapMinZoom: Double {
		get {
			return _mapMinZoom
		}
		set {
			_mapMinZoom = max(newValue, Const.mapMinZoom)
			_mapMinZoom = min(_mapMinZoom, Const.mapMaxZoom)
			self.js.setMapMinZoom(_mapMinZoom, completion: nil)
		}
	}

	/// Gets or sets the maximal zoom level of the map. This value can not be greater than 20.
	public var mapMaxZoom: Double {
		get {
			return _mapMaxZoom
		}
		set {
			_mapMaxZoom = max(newValue, Const.mapMinZoom)
			_mapMaxZoom = min(_mapMaxZoom, Const.mapMaxZoom)
			self.js.setMapMaxZoom(_mapMaxZoom, completion: nil)
		}
	}

	/// Gets or sets the map pitch angle.
	public var mapPitch: Double {
		get {
			return _mapPitch
		}
		set {
			_mapPitch = max(newValue, _mapMinPitch)
			_mapPitch = min(_mapPitch, _mapMaxPitch)
			self.js.setMapPitch(_mapPitch, completion: nil)
		}
	}

	/// Gets or sets the maximal pitch angle of the map. This value can not be less than 0.
	public var mapMinPitch: Double {
		get {
			return _mapMinPitch
		}
		set {
			_mapMinPitch = max(newValue, Const.mapMinPitch)
			_mapMinPitch = min(_mapMinPitch, Const.mapMaxPitch)
			self.js.setMapMinPitch(newValue, completion: nil)
		}
	}

	/// Gets or sets the mininal pitch angle of the map. This value can not be greater than 60.
	public var mapMaxPitch: Double {
		get {
			return _mapMaxPitch
		}
		set {
			_mapMaxPitch = max(newValue, Const.mapMinPitch)
			_mapMaxPitch = min(_mapMaxPitch, Const.mapMaxPitch)
			self.js.setMapMaxPitch(newValue, completion: nil)
		}
	}

	/// Initializes and shows the map. Important: all manipulations with the map must be done
	/// after the completion handler of this method is executed.
	///
	/// - Parameters:
	///   - apiKey: Secret key
	///   - center: Initial coordinates of the map center
	///   - zoom: Initial map zoom level
	///   - rotation: Initial map rotation angle
	///   - pitch: Initial map pinch angle
	///   - completion: Completion handler with the error information
	public func show(
		apiKey: String,
		center: CLLocationCoordinate2D? = nil,
		zoom: Double? = nil,
		rotation: Double? = nil,
		pitch: Double? = nil,
		completion: ((Error?) -> Void)? = nil
	) {
		if let center = center {
			_mapCenter = center
		}

		if let zoom = zoom {
			_mapZoom = max(zoom, _mapMinZoom)
			_mapZoom = min(_mapZoom, _mapMaxZoom)
		}

		if let rotation = rotation {
			_mapRotation = rotation
		}

		if let pitch = pitch {
			_mapPitch = max(pitch, _mapMinPitch)
			_mapPitch = min(_mapPitch, _mapMaxPitch)
		}

		self.loadHtml {
			[weak self] error in
			guard let self = self else { return }
			if let error = error {
				completion?(error)
				return
			}
			guard let bundleId = Bundle.main.bundleIdentifier else {
				completion?(MapGLError(text: "Error reading application Bundle Identifier"))
				return
			}
			self.initializeMap(apiKey: apiKey, bundleId: bundleId) {
				error in
				completion?(error)
			}
		}
	}

	/// Zoomes the map in.
	public func zoomIn() {
		self.mapZoom = min(self.mapZoom + 1, self.mapMaxZoom)
	}

	/// Zoomes the map out.
	public func zoomOut() {
		self.mapZoom = max(self.mapZoom - 1, self.mapMinZoom)
	}

	private func loadHtml(completion: @escaping (Error?) -> Void) {
		let frameworkBundle = Bundle(for: MapView.self)
		if let pathInFrameworkBundle = frameworkBundle.path(forResource: "Index", ofType: "html") {
			self.loadHtml(path: pathInFrameworkBundle, completion: completion)
		} else {
			guard let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("Map.bundle") else {
				completion(MapGLError(text: "Unable to read the resource bundle"))
				return
			}
			guard let resourceBundle = Bundle(url: bundleURL) else {
				completion(MapGLError(text: "Unable to create the resource bundle"))
				return
			}
			guard let pathInResourceBundle = resourceBundle.path(forResource: "Index", ofType: "html") else {
				completion(MapGLError(text: "Unable to find Index.html in the resource bundle"))
				return
			}
			self.loadHtml(path: pathInResourceBundle, completion: completion)
		}
	}

	private func loadHtml(path: String, completion: @escaping (Error?) -> Void) {
		let url = URL(fileURLWithPath: path)
		self.webView.loadFileURL(url, allowingReadAccessTo: url)
		self.initializeMap = {
			completion(nil)
		}
	}

	private func initializeMap(apiKey: String, bundleId: String, completion: @escaping ((Error?) -> Void)) {
		self.js.initializeMap(
			center: self.mapCenter,
			maxZoom: self.mapMaxZoom,
			minZoom: self.mapMinZoom,
			zoom: self.mapZoom,
			maxPitch: self.mapMaxPitch,
			minPitch: self.mapMinPitch,
			pitch: self.mapPitch,
			rotation: self.mapRotation,
			apiKey: apiKey,
			bundleId: bundleId
		) {
			result in
			switch result {
				case .success:
					self.centerDidChange?(self.mapCenter)
					self.zoomDidChange?(self.mapZoom)
					self.rotationDidChange?(self.mapRotation)
					self.pitchDidChange?(self.mapPitch)
					completion(nil)
				case .failure(let error):
					completion(error)
			}
		}
	}
}

extension MapView: WKNavigationDelegate {

	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		self.initializeMap?()
		self.initializeMap = nil
	}
}

extension MapView: JSExecutorProtocol {

	func evaluateJavaScript(_ javaScriptString: String, completion: ((Any?, Error?) -> Void)?) {
		self.webView.evaluateJavaScript(javaScriptString, completionHandler: completion)
	}
}

extension MapView: JSBridgeDelegate {

	func js(_ js: JSBridge, mapCenterDidChange mapCenter: CLLocationCoordinate2D) {
		_mapCenter = mapCenter
		self.centerDidChange?(mapCenter)
	}

	func js(_ js: JSBridge, mapZoomDidChange mapZoom: Double) {
		_mapZoom = mapZoom
		self.zoomDidChange?(mapZoom)
	}

	func js(_ js: JSBridge, mapRotationDidChange mapRotation: Double) {
		_mapRotation = mapRotation
		self.rotationDidChange?(mapRotation)
	}

	func js(_ js: JSBridge, mapPitchDidChange mapPitch: Double) {
		_mapPitch = mapPitch
		self.pitchDidChange?(mapPitch)
	}

	func js(_ js: JSBridge, didClickMapWithLocation location: CLLocationCoordinate2D) {
		self.mapClick?(location)
	}

	func js(_ js: JSBridge, didClickMarkerWithId makerId: String) {
		if let marker = self.markers[makerId] {
			marker.click?()
			self.markerClick?(marker)
		}
	}
}

extension MapView: MarkerDelegate {

	func marker(_ marker: Marker, didChangeCoordinates coordinates: CLLocationCoordinate2D) {
		self.js.setMarkerCoordinates(marker, coordinates: coordinates, completion: nil)
	}

	func markerDidHide(_ marker: Marker) {
		self.js.hideMarker(marker, completion: nil)
	}

	func markerDidShow(_ marker: Marker) {
		self.js.showMarker(marker, completion: nil)
	}

	func markerDidRemove(_ marker: Marker) {
		self.removeMarker(marker)
	}

}

extension MapView: PolygonDelegate {
}

extension MapView: CircleDelegate {
}

extension MapView: PolylineDelegate {
}

/// Objects
extension MapView {

	/// Adds the given marker to the map.
	///
	/// - Parameter marker: Marker to be added to the map.
	public func addMarker(_ marker: Marker) {
		marker.delegate = self
		self.markers[marker.id] = marker
		self.js.add(marker, completion: nil)
	}
	public func add(_ marker: Marker) {
		self.addMarker(marker)
	}

	/// Adds the given polygon to the map.
	/// - Parameter polygon: Polygon to be added to the map.
	public func add(_ polygon: Polygon) {
		polygon.delegate = self
		self.polygons[polygon.id] = polygon
		self.js.add(polygon)
	}

	/// Adds the given polygon to the map.
	/// - Parameter polygon: Polygon to be added to the map.
	public func add(_ polyline: Polyline) {
		polyline.delegate = self
		self.polylines[polyline.id] = polyline
		self.js.add(polyline)
	}

	public func remove(_ polyline: Polyline) {
		polyline.delegate = nil
		self.polylines.removeValue(forKey: polyline.id)
		self.js.destroy(polyline)
	}

	public func removeAllPolylines() {
		for polyline in self.polylines.values {
			self.remove(polyline)
		}
	}

	public func removeAllObjects() {
		self.removeAllPolygons()
		self.removeAllCircles()
		self.removeAllMarkers()
		self.removeAllPolylines()
	}

	/// Removes the given marker from the map.
	///
	/// - Parameter marker: Marker to be removed from the map
	public func removeMarker(_ marker: Marker) {
		marker.delegate = nil
		self.markers.removeValue(forKey: marker.id)
		self.js.destroy(marker, completion: nil)
	}

	/// Remover all the markers from the map.
	public func removeAllMarkers() {
		for marker in self.markers.values {
			self.removeMarker(marker)
		}
	}

	public func remove(_ polygon: Polygon) {
		polygon.delegate = nil
		self.polygons.removeValue(forKey: polygon.id)
		self.js.destroy(polygon)
	}
	public func removeAllPolygons() {
		for polygon in self.polygons.values {
			self.remove(polygon)
		}
	}
	/// Adds the given circle to the map.
	/// - Parameter circle: Circle to be added to the map.
	public func add(_ circle: Circle) {
		circle.delegate = self
		self.circles[circle.id] = circle
		self.js.add(circle)
	}

	/// Removes the given circle from the map.
	/// - Parameter circle: Circle to be removed from the map.
	public func remove(_ circle: Circle) {
		circle.delegate = nil
		self.circles.removeValue(forKey: circle.id)
		self.js.destroy(circle)
	}

	/// Removes all circles from the map.
	public func removeAllCircles() {
		for circle in self.circles.values {
			self.remove(circle)
		}
	}
}
