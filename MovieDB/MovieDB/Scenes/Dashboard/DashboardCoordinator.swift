import UIKit

protocol DashboardCoordinatorType: Coordinator {
    func goToWatchList()
    func goToMovieDetail(movieId: Int)
    func goToSearch(query: String)
}

final class DashboardCoordinator: DashboardCoordinatorType {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = DashboardViewModel(useCase: DashboardUseCase())
        var dashboardVC = DashboardViewController.instantiate().then {
            $0.coordinator = self
        }
        dashboardVC.bind(viewModel: viewModel)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(dashboardVC, animated: true)
    }

    func finish() {
    }
    
    func goToWatchList() {
        //TODO: navigation to WatchList Screen
    }
    
    func goToMovieDetail(movieId: Int) {
        //TODO: navigation to MovieDetail Screen
    }
    
    func goToSearch(query: String) {
        //TODO: navigation to Search Screen
    }
}
