import Foundation

/// Represents a floor plan of some building.
public class FloorPlan {
	/// An id of a floor plan.
	public let id: String
	/// Levels list.
	public let levels: [String]
	/// A current level name of a floor plan.
	public private(set) var currentLevel: String

	/// A current level index of a floor plan.
	public var currentLevelIndex: Int {
		get {
			return self._currentLevelIndex
		}
		set {
			guard (0 ..< self.levels.count).contains(newValue) else {
				let errorText = "Invalid floor level index"
				assertionFailure(errorText)
				return
			}
			self._currentLevelIndex = newValue
			self.currentLevel = self.levels[newValue]
			self.onLevelChanged(newValue)
		}
	}

	private var _currentLevelIndex: Int = 0
	private let onLevelChanged: (Int) -> Void

	init(
		id: String,
		levels: [String],
		currentLevelIndex: Int,
		onLevelChanged: @escaping (Int) -> Void
	) {
		assert(currentLevelIndex < levels.count, "Invalid level index of floor plan")

		self.id = id
		self.levels = levels
		self._currentLevelIndex = currentLevelIndex
		self.currentLevel = levels[currentLevelIndex]
		self.onLevelChanged = onLevelChanged
	}
}
