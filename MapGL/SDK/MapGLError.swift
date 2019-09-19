import Foundation

/// Represents the error occured in MapGL.
public class MapGLError : Error {

	/// Description of the error.
	public let localizedDescription: String

	/// Creates the new instance of the error object.
	///
	/// - Parameter text: Description of the error
	init(text: String) {
		self.localizedDescription = text
	}
}
