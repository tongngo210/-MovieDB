import UIKit

protocol WatchListCoordinatorType: Coordinator {
    func goToMovieDetail(movieId: Int)
}

final class WatchListCoordinator: WatchListCoordinatorType {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        var watchListVC = WatchListViewController.instantiate()
        let viewModel = WatchListViewModel(useCase: WatchListUseCase())
        watchListVC.coordinator = self
        watchListVC.set(viewModel: viewModel)
        
        navigationController?.pushViewController(watchListVC, animated: true)
    }

    func finish() {
        navigationController?.popViewController(animated: true)
    }
    
    func goToMovieDetail(movieId: Int) {
        //TODO: Navigate to movie detail
    }
}
