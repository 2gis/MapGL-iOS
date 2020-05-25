import XCTest
import CoreLocation
@testable import MapGL

class ExtensionTests: XCTestCase {

	func testCoordinate() {
		XCTAssertEqual(
			CLLocationCoordinate2D(latitude: 123.456, longitude: -123.456),
			CLLocationCoordinate2D(latitude: 123.456, longitude: -123.456)
		)
	}

}
