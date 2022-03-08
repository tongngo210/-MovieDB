import UIKit

protocol MovieDetailCoordinatorType {
    func finish()
}

final class MovieDetailCoordinator: Coordinator, MovieDetailCoordinatorType {
    var navigationController: UINavigationController?
    var movieId: Int
    
    init(navigationController: UINavigationController?, movieId: Int) {
        self.navigationController = navigationController
        self.movieId = movieId
    }

    func start() {
        let viewModel = MovieDetailViewModel(useCase: MovieDetailUseCase(),
                                             movieId: movieId)
        var dashboardVC = MovieDetailViewController.instantiate()
        dashboardVC.coordinator = self
        dashboardVC.set(viewModel: viewModel)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(dashboardVC, animated: true)
    }

    func finish() {
        navigationController?.popViewController(animated: true)
    }
}
