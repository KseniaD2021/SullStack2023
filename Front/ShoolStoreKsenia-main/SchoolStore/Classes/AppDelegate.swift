
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Internal

    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let initialVC: UIViewController? = dataService.appState.isUserAuthenticated ? VCFactory.buildTabBarVC() : VCFactory.buildAuthVC()

        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        configureNavigationBar()
        return true
    }

    // MARK: Private

    private let dataService: DataService = CoreFactory.dataService
}
