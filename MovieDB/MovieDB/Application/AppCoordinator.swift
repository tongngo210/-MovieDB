import UIKit

class AppCoordinator {

    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        let dashboardCoordinator = DashboardCoordinator(navigationController: navigationController)
        dashboardCoordinator.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func finish() {
    }
}
