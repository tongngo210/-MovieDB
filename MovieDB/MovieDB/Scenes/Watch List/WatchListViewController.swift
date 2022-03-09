import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx
import Then

final class WatchListViewController: UIViewController, StoryboardBased, Bindable {
    struct Constants {
        static let movieListTableViewRowHeight: CGFloat = 138
    }
    @IBOutlet private weak var favoriteMovieTableView: UITableView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    var viewModel: WatchListViewModel!
    var coordinator: WatchListCoordinator!
    
    private var input: WatchListViewModel.Input!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.notification.onNext(())
    }
    
    func bind() {
        let bookmarkButtonTrigger = PublishSubject<Int>()
        let readMoreButtonTrigger = PublishSubject<Int>()
        
        input = WatchListViewModel
            .Input(loadTrigger: Driver.just(()),
                   notification: PublishSubject<Void>(),
                   bookmarkButtonTrigger: bookmarkButtonTrigger)
        
        let output = viewModel.transform(input)
        
        output.favoriteMovies
            .drive(favoriteMovieTableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: FavoriteMovieItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                let viewModel = FavoriteMovieItemTableViewCellViewModel(favoriteMovie: item)
                cell.set(viewModel: viewModel,
                         bookmarkButtonTrigger: bookmarkButtonTrigger,
                         readMoreButtonTrigger: readMoreButtonTrigger)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        
        readMoreButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.coordinator.goToMovieDetail(movieId: $0)
            })
            .disposed(by: rx.disposeBag)
        
        backButton.rx.tap.asDriver()
            .do(onNext: { [weak self] in
                self?.coordinator.finish()
            })
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
//MARK: - Configure UI
extension WatchListViewController {
    private func configView() {
        configTableView()
    }
    
    private func configTableView() {
        favoriteMovieTableView.do {
            $0.register(cellType: FavoriteMovieItemTableViewCell.self)
            $0.rowHeight = Constants.movieListTableViewRowHeight
        }
    }
}
