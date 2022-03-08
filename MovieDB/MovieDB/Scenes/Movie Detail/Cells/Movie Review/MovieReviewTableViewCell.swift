import UIKit
import Reusable

final class MovieReviewTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var reviewerImageView: UIImageView!
    @IBOutlet private weak var reviewerNameLabel: UILabel!
    @IBOutlet private weak var movieReviewContentLabel: UILabel!
    @IBOutlet private weak var movieReviewRatingLabel: UILabel!
    
    var viewModel: MovieReviewTableViewCellViewModel!
    
    func set(viewModel: MovieReviewTableViewCellViewModel) {
        self.viewModel = viewModel
        reviewerImageView.sd_setImage(with: URL(string: viewModel.reviewerAvatarURLString),
                                      placeholderImage: UIImage(named: AppName.Image.defaultAvatar))
        reviewerNameLabel.text = viewModel.reviewerName
        movieReviewContentLabel.text = viewModel.movieReviewContent
        movieReviewRatingLabel.text = "\(viewModel.movieReviewRating)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    func configCell() {
        reviewerImageView.cornerRadius = reviewerImageView.frame.height / 2
    }
}
