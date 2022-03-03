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
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    var viewModel: MovieItemTableViewCellViewModel! {
        didSet {
            movieImageView.sd_setImage(with: URL(string: APIURLs.Image.original + viewModel.poster),
                                       completed: nil)
            movieNameLabel.text = viewModel.title
            movieReleaseDateLabel.text = viewModel.releaseDate
            movieAverageRateLabel.text = "\(viewModel.voteRate)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    private func configCell() {
    }
}
