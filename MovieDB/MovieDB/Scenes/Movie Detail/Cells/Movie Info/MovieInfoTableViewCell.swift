import UIKit
import Reusable

final class MovieInfoTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var movieSynopsisLabel: UILabel!
    @IBOutlet private weak var movieReleaseDateLabel: UILabel!
    @IBOutlet private weak var movieRateLabel: UILabel!
    @IBOutlet private weak var movieRateCountLabel: UILabel!
    @IBOutlet private weak var moviePopularityLabel: UILabel!
    
    var viewModel: MovieInfoTableViewCellViewModel!
    
    func set(viewModel: MovieInfoTableViewCellViewModel) {
        self.viewModel = viewModel
        movieSynopsisLabel.text = viewModel.synopsis
        movieReleaseDateLabel.text = viewModel.releaseDate
        movieRateLabel.text = "\(viewModel.voteRate)"
        movieRateCountLabel.text = "\(viewModel.voteRateCount)"
        moviePopularityLabel.text = "\(viewModel.popularity)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
