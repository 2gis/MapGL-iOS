import Foundation

/// Represents the error occured in MapGL.
public class MapGLError : Error, LocalizedError {

	/// Description of the error.
	private let text: String

	/// Creates the new instance of the error object.
	///
	/// - Parameter text: Description of the error
	init(text: String) {
		self.text = text
	}

	public var errorDescription: String? {
		return self.text
	}

}
