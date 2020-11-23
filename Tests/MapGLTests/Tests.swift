import XCTest
import CoreLocation
@testable import MapGL

class Tests: XCTestCase {

	private var jsExecutor: JSExecutor!
	private var map: MapView!

	private lazy var testMarkerImage: UIImage = {
		let imageDataString = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
		let imageData = Data(base64Encoded: imageDataString)!
		let image = UIImage(data: imageData)!
		return image
	}()

	private lazy var testMarkerImageBase64String: String = {
		return self.testMarkerImage.pngData()!.base64EncodedString()
	}()

	override func setUp() {
		self.jsExecutor = JSExecutor()
		self.map = MapView(jsExecutor: self.jsExecutor)
	}

	func test_map_initial_state() {
		XCTAssertEqual(self.map.mapCenter.latitude, MapView.Const.mapDefaultCenter.latitude)
		XCTAssertEqual(self.map.mapCenter.longitude, MapView.Const.mapDefaultCenter.longitude)
		XCTAssertEqual(self.map.mapRotation, MapView.Const.mapDefaultRotation)
		XCTAssertEqual(self.map.mapZoom, MapView.Const.mapDefaultZoom)
		XCTAssertEqual(self.map.mapMinZoom, MapView.Const.mapDefaultMinZoom)
		XCTAssertEqual(self.map.mapMaxZoom, MapView.Const.mapDefaultMaxZoom)
		XCTAssertEqual(self.map.mapPitch, MapView.Const.mapDefaultPitch)
		XCTAssertEqual(self.map.mapMinPitch, MapView.Const.mapDefaultMinPitch)
		XCTAssertEqual(self.map.mapMaxPitch, MapView.Const.mapDefaultMaxPitch)
	}

	func test_map_zoom_cannot_be_less_than_min_zoom() {
		self.map.mapMaxZoom = 11
		self.map.mapMinZoom = 10
		self.map.mapZoom = 0
		XCTAssertEqual(self.map.mapZoom, 10)
	}

	func test_map_zoom_cannot_be_greater_than_max_zoom() {
		self.map.mapMaxZoom = 11
		self.map.mapMinZoom = 10
		self.map.mapZoom = 100
		XCTAssertEqual(self.map.mapZoom, 11)
	}

	func test_map_max_zoom_cannot_be_greater_than_its_max_value() {
		self.map.mapMaxZoom = 100
		XCTAssertEqual(self.map.mapMaxZoom, MapView.Const.mapMaxZoom)
	}

	func test_map_min_zoom_cannot_be_less_than_its_min_value() {
		self.map.mapMaxZoom = 0
		XCTAssertEqual(self.map.mapMaxZoom, MapView.Const.mapMinZoom)
	}

	func test_map_pitch_cannot_be_greater_than_max_pitch() {
		self.map.mapMaxPitch = 60
		self.map.mapMinPitch = 0
		self.map.mapPitch = 100
		XCTAssertEqual(self.map.mapPitch, 60)
	}

	func test_map_pitch_cannot_be_less_than_min_pitch() {
		self.map.mapMaxPitch = 60
		self.map.mapMinPitch = 10
		self.map.mapPitch = 0
		XCTAssertEqual(self.map.mapPitch, 10)
	}

	func test_map_max_pitch_cannot_be_greater_than_its_max_value() {
		self.map.mapMaxPitch = 100
		XCTAssertEqual(self.map.mapMaxPitch, MapView.Const.mapMaxPitch)
	}

	func test_map_min_pitch_cannot_be_less_than_its_min_value() {
		self.map.mapMinPitch = -1
		XCTAssertEqual(self.map.mapMinPitch, MapView.Const.mapMinPitch)
	}

	func test_execute_js_on_center_change() {
		self.map.mapCenter = CLLocationCoordinate2D(latitude: 1, longitude: 2)
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setCenter([2.0,1.0]);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_zoom_change() {
		self.map.mapZoom = 10
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setZoom(10.0, undefined);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_min_zoom_change() {
		self.map.mapMinZoom = 5
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setMinZoom(5.0);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_max_zoom_change() {
		self.map.mapMaxZoom = 10
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setMaxZoom(10.0);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_pitch_change() {
		self.map.mapPitch = 42
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setPitch(42.0);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_min_pitch_change() {
		self.map.mapMinPitch = 5
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setMinPitch(5.0);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_max_pitch_change() {
		self.map.mapMaxPitch = 30
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setMaxPitch(30.0);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_rotation_change() {
		self.map.mapRotation = 45
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setRotation(45.0);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_add_marker_without_image() {
		let expected = """
		window.addMarker({coordinates:[2.0,1.0],id:"123"});
		"""
		self.map.add(self.testMarkerWithoutImage())
		XCTAssertEqual(self.jsExecutor.javaScriptString, expected)
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_add_marker_with_image() {
		let expected = """
		window.addMarker({anchor:[0,0],coordinates:[2.0,1.0],icon:"data:image/png;base64,\(self.testMarkerImageBase64String)",id:"123",size:[1.0,1.0]});
		"""
		self.map.add(self.testMarkerWithImage(self.testMarkerImage, anchor: .leftTop))
		XCTAssertEqual(self.jsExecutor.javaScriptString, expected)
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_remove_marker_using_marker() {
		let marker = self.testMarkerWithoutImage()
		self.map.add(marker)
		self.map.remove(marker)
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.destroyObject(\"123\");")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 2)
	}

	func test_execute_js_on_remove_marker_using_map() {
		let marker = self.testMarkerWithoutImage()
		self.map.add(marker)
		self.map.remove(marker)
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.destroyObject(\"123\");")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 2)
	}

	func test_execute_js_on_hide_marker() {
		let marker = self.testMarkerWithoutImage()
		self.map.add(marker)
		marker.isHidden = true
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.hideObject(\"123\");")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 2)
	}

	func test_execute_js_on_show_marker() {
		let marker = self.testMarkerWithoutImage()
		self.map.add(marker)
		marker.isHidden = true
		marker.isHidden = false
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.showObject(\"123\");")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 3)
	}

	func test_execute_js_on_marker_change_location() {
		let marker = self.testMarkerWithoutImage()
		self.map.add(marker)
		marker.coordinates = CLLocationCoordinate2D(latitude: 3, longitude: 4)
		let expected = """
		window.setMarkerCoordinates(
		"123",
		[4.0,3.0]
		);
		"""
		XCTAssertEqual(self.jsExecutor.javaScriptString, expected)
		XCTAssertEqual(self.jsExecutor.invocationsCount, 2)
	}

	private func testMarkerWithImage(
		_ image: UIImage?,
		anchor: Marker.Anchor = .center
	) -> Marker {
		let marker = Marker(
			id: "123",
			coordinates: CLLocationCoordinate2D(latitude: 1, longitude: 2),
			image: image,
			anchor: anchor
		)
		return marker
	}

	private func testMarkerWithoutImage() -> Marker {
		return self.testMarkerWithImage(nil)
	}
}
