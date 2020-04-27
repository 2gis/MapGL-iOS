import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		self.window = UIWindow()
		let root = HelloVC()
		self.window?.rootViewController = root
		self.window?.makeKeyAndVisible()
		return true
	}
}
