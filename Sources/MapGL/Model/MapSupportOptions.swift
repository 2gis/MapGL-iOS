import Foundation

/// Options for Map.isSupported method.
public struct MapSupportOptions {
	/// Causes `isSupported` to return false if performance of MapGL would be
	/// dramatically worse than expected (i.e. a software renderer would be used)
	public let failIfMajorPerformanceCaveat: Bool

	public init(failIfMajorPerformanceCaveat: Bool) {
		self.failIfMajorPerformanceCaveat = failIfMajorPerformanceCaveat
	}
}
