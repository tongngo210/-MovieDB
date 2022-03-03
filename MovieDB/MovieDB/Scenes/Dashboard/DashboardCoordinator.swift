import UIKit

protocol DashboardCoordinatorType {
    func goToWatchList()
    func goToMovieDetail(movieId: Int)
    func goToSearch(query: String)
}

final class DashboardCoordinator: Coordinator, DashboardCoordinatorType {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        var dashboardVC = DashboardViewController.instantiate()
        let useCase = DashboardUseCase()
        let viewModel = DashboardViewModel(coordinator: self,
                                           useCase: useCase)
        dashboardVC.bind(to: viewModel)
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(dashboardVC, animated: true)
    }

    func finish() {
    }
    
    func goToWatchList() {
        //navigation to WatchList Screen
    }
    
    func goToMovieDetail(movieId: Int) {
        //navigation to MovieDetail Screen
    }
    
    func goToSearch(query: String) {
        //navigation to Search Screen
    }
}
