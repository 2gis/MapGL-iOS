import Foundation

/// Base map object protocol
@objc public protocol IMapObject {
	/// Unique object id, used to search objects on map
	var id: String { get }
}

internal protocol IJSMapObject: IMapObject {
	func createJSCode() -> String
	func destroyJSCode() -> String
}
