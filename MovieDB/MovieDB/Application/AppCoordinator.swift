import UIKit

class AppCoordinator {

    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        // Navigate to Dashboard Screen
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func finish() {
    }
}
