import CoreLocation

/// A class that provides driving direction functionality.
public class Directions: MapObject {

	private let apiKey: String
	private var completions: [String: (Result<Void, MapGLError>) -> Void] = [:]

	/// Directions API access key
	/// - Parameter apiKey: Your Directions API access key
	init(apiKey: String) {
		self.apiKey = apiKey
		super.init()
	}

	/// Finds and draws an optimal car route.
	/// - Note: You can set up to 10 points.
	/// - Parameters:
	///   - points: Array of geographical points.
	///   - completion: Completion hendler.
	public func showCarRoute(points: [CLLocationCoordinate2D], completion: @escaping (Result<Void, MapGLError>) -> Void) {
		assert(
			points.count >= 2 && points.count <= 10,
			"To build a route you should use from two up to 10 points"
		)
		let completionid = UUID().uuidString
		let options = "{ points: \(points.jsValue()) }"
		let js = "window.carRoute(\(self.id.jsValue()), \(completionid.jsValue()), \(options));"
		self.completions[completionid] = completion
		self.evaluateJS(js)
	}

	/// Clears the map from any previously drawn routes.
	public func clear() {
		let js = "window.clearCarRoute(\(self.id.jsValue()));"
		self.evaluateJS(js)
		self.completions.removeAll()
	}

	func invokeCompletion(with id: String, result: Result<Void, MapGLError>) {
		if let completion = completions[id] {
			completion(result)
			completions[id] = nil
		}
	}

}

extension Directions {

	override func createJSCode() -> String {
		let js = """
		window.directions(\(self.id.jsValue()), \(self.apiKey.jsValue()));
		"""
		return js
	}

	override func destroyJSCode() -> String {
		let js = """
		window.destroyDirections(\(self.id.jsValue()));
		"""
		return js
	}

}
