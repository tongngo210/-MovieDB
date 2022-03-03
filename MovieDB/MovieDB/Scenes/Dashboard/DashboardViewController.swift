import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx
import Then

fileprivate enum ConstantDashboard {
    static let movieListTableViewRowHeight = CGFloat(138)
    static let fontSizeCategoryTitle = CGFloat(12)
}

final class DashboardViewController: UIViewController, StoryboardBased, Bindable {
    @IBOutlet private weak var categoryListCollectionView: UICollectionView!
    @IBOutlet private weak var movieListTableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var watchListButton: UIButton!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = DashboardViewModel
            .Input(loadTrigger: Driver.just(()),
                   searchButtonTrigger: searchButton.rx.tap.asDriver(),
                   watchListButtonTrigger: watchListButton.rx.tap.asDriver(),
                   loadMoreButtonTrigger: loadMoreButton.rx.tap.asDriver(),
                   searchText: searchTextField.rx.text.orEmpty.asDriver(),
                   categorySelectedTrigger: categoryListCollectionView.rx.modelSelected(CategoryType.self).asDriver(),
                   movieSelectedTrigger: movieListTableView.rx.modelSelected(Movie.self).asDriver())
        
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.categoryItems
            .asDriver()
            .drive(categoryListCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: CategoryItemCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.viewModel = CategoryItemCollectionViewCellViewModel(category: item)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.movieItems
            .asDriver()
            .drive(movieListTableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.viewModel = MovieItemTableViewCellViewModel(movie: item)

                //MARK: - Bookmark Button Action
                cell.bookmarkButton.rx.tap.asDriver()
                    .do(onNext: {
                        //Save local using Core Data
                    })
                    .drive()
                    .disposed(by: cell.disposeBag)

                //MARK: - Star Button Action
                cell.starButton.rx.tap.asDriver()
                    .do(onNext: {
                        //Do something
                    })
                    .drive()
                    .disposed(by: cell.disposeBag)

                return cell
            }
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
            string: AppText.searchTextFieldPlaceHolder,
            attributes: [NSAttributedString.Key.foregroundColor: AppColor.gallery]
        )
    }
    
    private func configTableView() {
        movieListTableView.do {
            $0.register(cellType: MovieItemTableViewCell.self)
            $0.rowHeight = ConstantDashboard.movieListTableViewRowHeight
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
                NSAttributedString.Key.font : UIFont(name: AppFont.poppinsSemiBold,
                                                     size: ConstantDashboard.fontSizeCategoryTitle) ?? UIFont()
            ])
            return CGSize(width: itemSize.width * 3 / 2,
                          height: collectionView.frame.height)
        }
        return CGSize()
    }
}
