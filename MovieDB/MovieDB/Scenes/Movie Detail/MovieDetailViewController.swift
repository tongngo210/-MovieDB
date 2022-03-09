import UIKit
import RxSwift
import RxCocoa
import Reusable
import NSObject_Rx
import Then

final class MovieDetailViewController: UIViewController, StoryboardBased, Bindable {
    @IBOutlet private weak var aboutMovieButtonUnderLineView: UIView!
    @IBOutlet private weak var reviewsButtonUnderLineView: UIView!
    @IBOutlet private weak var movieBackgroundPosterImageView: UIImageView!
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var aboutMovieButton: UIButton!
    @IBOutlet private weak var reviewsButton: UIButton!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var movieGenreCollectionView: UICollectionView!
    @IBOutlet private weak var movieInfoTableView: UITableView!
    @IBOutlet private weak var movieReviewsTableView: UITableView!
    
    var viewModel: MovieDetailViewModel!
    var coordinator: MovieDetailCoordinator!
    
    private var input: MovieDetailViewModel.Input!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
    }
    
    func bind() {
        input = MovieDetailViewModel
            .Input(loadTrigger: Driver.just(()),
                   bookmarkButtonTrigger: bookmarkButton.rx.tap.asDriver(),
                   isMovieFavorited: BehaviorRelay<Bool>(value: false),
                   movieGenres: BehaviorRelay<[Genre]>(value: []))
        
        let output = viewModel.transform(input)
        
        output.movieInfo
            .map { [$0] }
            .drive(movieInfoTableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.set(viewModel: MovieInfoTableViewCellViewModel(movieDetail: item))
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.movieInfo
            .drive(movieDetailBinder)
            .disposed(by: rx.disposeBag)
        
        output.movieGenres
            .drive(movieGenreCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieGenreCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.set(viewModel: MovieGenreCollectionViewCellViewModel(genre: item))
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.movieReviews
            .drive(movieReviewsTableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieReviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.set(viewModel: MovieReviewTableViewCellViewModel(movieReview: item))
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.isMovieFavorited
            .drive(isMovieFavorited)
            .disposed(by: rx.disposeBag)
        
        output.bookmarkButtonTrigger
            .drive(isMovieFavorited)
            .disposed(by: rx.disposeBag)
        
        aboutMovieButton.rx.tap.asDriver()
            .drive(aboutMovieButtonTrigger)
            .disposed(by: rx.disposeBag)
        
        reviewsButton.rx.tap.asDriver()
            .drive(reviewsButtonTrigger)
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
extension MovieDetailViewController {
    private func configView() {
        configButtonUnderlineView()
        configTableView()
        configCollectionView()
    }
    
    private func configButtonUnderlineView() {
        aboutMovieButtonUnderLineView.alpha = 1
        reviewsButtonUnderLineView.alpha = 0
    }
    
    private func configTableView() {
        movieInfoTableView.do {
            $0.register(cellType: MovieInfoTableViewCell.self)
            $0.isHidden = false
        }
            
        movieReviewsTableView.do {
            $0.register(cellType: MovieReviewTableViewCell.self)
            $0.isHidden = true
        }
    }
    
    private func configCollectionView() {
        movieGenreCollectionView.do {
            $0.register(cellType: MovieGenreCollectionViewCell.self)
            $0.delegate = self
        }
    }
    
    private func fillData(with movieDetail: MovieDetail) {
        movieBackgroundPosterImageView.sd_setImage(with: URL(string: APIURLs.Image.original + (movieDetail.backgroundPoster ?? "")),
                                                   completed: nil)
        moviePosterImageView.sd_setImage(with: URL(string: APIURLs.Image.original + (movieDetail.poster ?? "")),
                                                   completed: nil)
        movieNameLabel.text = movieDetail.title
    }
    
    private func animateButtonUnderlines(isTappedAboutMovieButton: Bool = false,
                                         isTappedReviewsButton: Bool = false) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.aboutMovieButtonUnderLineView.alpha = isTappedAboutMovieButton ? 1 : 0
            self?.reviewsButtonUnderLineView.alpha = isTappedReviewsButton ? 1 : 0
        }
    }
}
//MARK: - Binder
extension MovieDetailViewController {
    private var movieDetailBinder: Binder<MovieDetail> {
        return Binder(self) { vc, movieDetail in
            vc.fillData(with: movieDetail)
        }
    }
    
    private var aboutMovieButtonTrigger: Binder<Void> {
        return Binder(self) { vc, _ in
            vc.animateButtonUnderlines(isTappedAboutMovieButton: true)
            vc.movieInfoTableView.isHidden = false
            vc.movieReviewsTableView.isHidden = true
        }
    }
    
    private var reviewsButtonTrigger: Binder<Void> {
        return Binder(self) { vc, _ in
            vc.animateButtonUnderlines(isTappedReviewsButton: true)
            vc.movieInfoTableView.isHidden = true
            vc.movieReviewsTableView.isHidden = false
        }
    }
    
    private var isMovieFavorited: Binder<Bool> {
        return Binder(self) { vc, isFavorited in
            let imageName = isFavorited ? AppName.Image.blackBookmarkCheck : AppName.Image.whiteBookmarkSmall
            let imageBackgroundColor = isFavorited ? AppColor.puertoRico : AppColor.brightGray
            vc.bookmarkButton.do {
                $0.setImage(UIImage(named: imageName), for: .normal)
                $0.backgroundColor = imageBackgroundColor
            }
        }
    }
}
//MARK: - Collection View Delegate Flow Layout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if 0..<input.movieGenres.value.count ~= indexPath.item {
            let item = input.movieGenres.value[indexPath.item]
            let itemSize = item.name.size(withAttributes: [
                NSAttributedString.Key.font : UIFont.setPoppinsFont(style: .poppinsRegular,
                                                                    size: .twelve)
                
            ])
            return CGSize(width: itemSize.width * 2,
                          height: collectionView.frame.height)
        }
        return CGSize()
    }
}
