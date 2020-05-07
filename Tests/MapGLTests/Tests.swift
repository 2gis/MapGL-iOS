import XCTest
import CoreLocation
@testable import MapGL

class Tests: XCTestCase {

	private var jsExecutor: JSExecutor!
	private var map: MapView!

	private lazy var testMarkerImage: UIImage = {
		let imageDataString = "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"
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
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setCenter([2.0, 1.0]);")
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_zoom_change() {
		self.map.mapZoom = 10
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.map.setZoom(10.0);")
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
		window.addMarker({
		id: "123",
		coordinates: [2.0, 1.0],
		icon: undefined,
		anchor: undefined,
		size: undefined,
		});
		"""
		self.map.add(self.testMarkerWithoutImage())
		XCTAssertEqual(self.jsExecutor.javaScriptString, expected)
		XCTAssertEqual(self.jsExecutor.invocationsCount, 1)
	}

	func test_execute_js_on_add_marker_with_image() {
		let expected = """
		window.addMarker({
		id: "123",
		coordinates: [2.0, 1.0],
		icon: "data:image/png;base64,\(self.testMarkerImageBase64String)",
		anchor: [0, 0],
		size: [120.0, 177.0],
		});
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
		XCTAssertEqual(self.jsExecutor.javaScriptString, "window.setMarkerCoordinates(\n\"123\",\n[4.0, 3.0]\n);")
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
