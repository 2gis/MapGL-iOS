import Foundation

@objc public protocol IMapObject {
	var id: String { get }
}

internal protocol IJSMapObject: IMapObject {
	func createJSCode() -> String
	func destroyJSCode() -> String
}
