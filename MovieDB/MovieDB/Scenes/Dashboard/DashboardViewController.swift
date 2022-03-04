import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx
import Then

final class DashboardViewController: UIViewController, StoryboardBased, Bindable {
    private struct Constants {
        static let movieListTableViewRowHeight: CGFloat = 138
    }
    
    @IBOutlet private weak var categoryListCollectionView: UICollectionView!
    @IBOutlet private weak var movieListTableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var watchListButton: UIButton!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    var viewModel: DashboardViewModel!
    var coordinator: DashboardCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let bookmarkButtonTrigger = PublishSubject<Void>()
        let starButtonTrigger = PublishSubject<Void>()
        
        let input = DashboardViewModel
            .Input(loadTrigger: Driver.just(()),
                   loadMoreButtonTrigger: loadMoreButton.rx.tap.asDriver(),
                   categorySelectedTrigger: categoryListCollectionView.rx.modelSelected(CategoryType.self).asDriver(),
                   pageNumber: BehaviorRelay<Int>(value: 1),
                   movieItems: BehaviorRelay<[Movie]>(value: []),
                   bookmarkButtonTrigger: bookmarkButtonTrigger,
                   starButtonTrigger: starButtonTrigger)
        
        let output = viewModel.transform(input)
        
        output.categoryItems
            .drive(categoryListCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: CategoryItemCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.viewModel = CategoryItemCollectionViewCellViewModel(category: item)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.firstPageMovies
            .drive(output.movieItems)
            .disposed(by: rx.disposeBag)
        
        output.nextPageMovies
            .drive { output.movieItems.accept(output.movieItems.value + $0) }
            .disposed(by: rx.disposeBag)
        
        output.movieItems
            .asDriver()
            .drive(movieListTableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                let viewModel = MovieItemTableViewCellViewModel(movie: item)
                cell.bindViewModel(viewModel: viewModel,
                                   bookmarkButtonTrigger: bookmarkButtonTrigger,
                                   starButtonTrigger: starButtonTrigger)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.saveFavoriteMovie
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.voteMovie
            .drive()
            .disposed(by: rx.disposeBag)
        //MARK: - Navigation
        searchButton.rx
            .tap
            .withLatestFrom(searchTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] in
                self?.coordinator.goToSearch(query: $0)
            })
            .disposed(by: rx.disposeBag)
                
        watchListButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator.goToWatchList()
            })
            .disposed(by: rx.disposeBag)
                
        movieListTableView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] in
                self?.coordinator.goToMovieDetail(movieId: $0.id)
            })
            .disposed(by: rx.disposeBag)
    }
}
//MARK: - Configure UI
extension DashboardViewController {
    private func configView() {
        configTextField()
        configTableView()
        configCollectionView()
    }
    
    private func configTextField() {
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: AppText.searchTextFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: AppColor.gallery]
        )
    }
    
    private func configTableView() {
        movieListTableView.do {
            $0.register(cellType: MovieItemTableViewCell.self)
            $0.rowHeight = Constants.movieListTableViewRowHeight
        }
    }
    
    private func configCollectionView() {
        categoryListCollectionView.do {
            $0.register(cellType: CategoryItemCollectionViewCell.self)
            $0.delegate = self
        }
    }
}
//MARK: - CollectionView Delegate Flow Layout
extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if 0..<CategoryType.allCases.count ~= indexPath.item {
            let item = CategoryType.allCases[indexPath.item]
            let itemSize = item.title.size(withAttributes: [
                NSAttributedString.Key.font : UIFont.setPoppinsFont(style: .poppinsSemiBold,
                                                                    size: .twelve)
            ])
            return CGSize(width: itemSize.width * 3 / 2,
                          height: collectionView.frame.height)
        }
        return CGSize()
    }
}
