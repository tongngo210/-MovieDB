import UIKit
import RxSwift
import RxCocoa
import Reusable
import SDWebImage

final class MovieItemTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieReleaseDateLabel: UILabel!
    @IBOutlet private weak var movieAverageRateLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var starButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    func set(viewModel: MovieItemTableViewCellViewModel,
             bookmarkButtonTrigger: PublishSubject<Void>,
             starButtonTrigger: PublishSubject<Void>) {
        movieImageView.sd_setImage(with: URL(string: APIURLs.Image.original + viewModel.poster),
                                   completed: nil)
        movieNameLabel.text = viewModel.title
        movieReleaseDateLabel.text = viewModel.releaseDate
        movieAverageRateLabel.text = "\(viewModel.voteRate)"
        
        bookmarkButton.rx.tap
            //TODO: Map to FavoriteMovie
            .bind(to: bookmarkButtonTrigger)
            .disposed(by: disposeBag)
        
        starButton.rx.tap
            .bind(to: starButtonTrigger)
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
