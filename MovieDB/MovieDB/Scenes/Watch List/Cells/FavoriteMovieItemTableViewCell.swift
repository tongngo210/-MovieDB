import UIKit
import RxSwift
import RxCocoa
import Reusable
import SDWebImage

final class FavoriteMovieItemTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var favoriteMovieImageView: UIImageView!
    @IBOutlet private weak var favoriteMovieNameLabel: UILabel!
    @IBOutlet private weak var favoriteMovieReleaseDateLabel: UILabel!
    @IBOutlet private weak var favoriteMovieRateLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel: FavoriteMovieItemTableViewCellViewModel!
    
    func set(viewModel: FavoriteMovieItemTableViewCellViewModel,
             bookmarkButtonTrigger: PublishSubject<Int>,
             readMoreButtonTrigger: PublishSubject<Int>) {
        self.viewModel = viewModel
        favoriteMovieImageView.sd_setImage(with: URL(string: APIURLs.Image.original + viewModel.poster),
                                           completed: nil)
        favoriteMovieNameLabel.text = viewModel.title
        favoriteMovieReleaseDateLabel.text = viewModel.releaseDate
        favoriteMovieRateLabel.text = "\(viewModel.voteRate)"
        
        bookmarkButton.rx.tap
            .map { viewModel.id }
            .bind(to: bookmarkButtonTrigger)
            .disposed(by: disposeBag)
        
        readMoreButton.rx.tap
            .map { viewModel.id }
            .bind(to: readMoreButtonTrigger)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
