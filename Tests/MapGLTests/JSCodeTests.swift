import XCTest
import CoreLocation
@testable import MapGL

class JSCodeTests: XCTestCase {

	func testJSString() {
		XCTAssertEqual("".jsValue(), "\"\"")
		XCTAssertEqual("1".jsValue(), "\"1\"")
		XCTAssertEqual([""].jsValue(), "[\"\"]")
		XCTAssertEqual(["1", "2"].jsValue(), "[\"1\",\"2\"]")
	}

	func testOptional() {
		var a: String?
		XCTAssertEqual(a.jsValue(), "undefined")
		a = "123"
		XCTAssertEqual(a.jsValue(), "\"123\"")
		var b = [String?]()
		XCTAssertEqual(b.jsValue(), "[]")
		b.append(nil)
		XCTAssertEqual(b.jsValue(), "[undefined]")
		b.append(nil)
		XCTAssertEqual(b.jsValue(), "[undefined,undefined]")
		b.append("123")
		XCTAssertEqual(b.jsValue(), "[undefined,undefined,\"123\"]")
	}

	func testCoordinates() {
		var c: CLLocationCoordinate2D?
		XCTAssertEqual(c.jsValue(), "undefined")
		c = CLLocationCoordinate2D(latitude: 123.567, longitude: -123.456)
		XCTAssertEqual(c.jsValue(), "[-123.456,123.567]")
		var coordinates = [CLLocationCoordinate2D]()
		XCTAssertEqual(coordinates.jsValue(), "[]")
		coordinates.append(c!)
		XCTAssertEqual(coordinates.jsValue(), "[[-123.456,123.567]]")
	}

	func testColor() {
		XCTAssertEqual(UIColor.black.jsValue(), "\"#000000\"")
		XCTAssertEqual(UIColor.black.withAlphaComponent(0.5).jsValue(), "\"#0000007F\"")
	}

	func testMixed() {
		let stirng: String? = nil
		let array: [IJSValue] = [
			stirng,
			"",
			1,
			CLLocationCoordinate2D(latitude: 1, longitude: 2),
			UIColor.yellow,
			CGFloat(2.2),
		]
		let str = #"""
		[undefined,"",1,[2.0,1.0],"#FFFF00",2.2]
		"""#
		XCTAssertEqual(array.jsValue(), str)
	}

	func testPolyline() {
		var style: PolylineStyle?
		XCTAssertEqual(style.jsValue(), "undefined,undefined,undefined")
		style = PolylineStyle(color: .red, width: 5, z: 5)
		XCTAssertEqual(style.jsValue(), """
		"#FF0000",5.0,5
		""")
	}

	struct JSOptions: IJSOptions {
		let dict: [String : IJSValue]
		init(_ dict: [String : IJSValue]) {
			self.dict = dict
		}
		func jsKeyValue() -> [String : IJSValue] { self.dict }
	}

	func testJSMap() {
		let a = JSOptions(["a": 1])
		XCTAssertEqual(a.jsValue(), "{a:1}")

		let b = JSOptions(["b": "b"])
		XCTAssertEqual(b.jsValue(), "{b:\"b\"}")
	}

}
