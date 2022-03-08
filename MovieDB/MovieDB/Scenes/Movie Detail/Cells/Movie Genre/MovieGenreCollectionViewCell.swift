import UIKit
import Reusable

final class MovieGenreCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var genreNameLabel: UILabel!
    
    var viewModel: MovieGenreCollectionViewCellViewModel!
    
    func set(viewModel: MovieGenreCollectionViewCellViewModel) {
        self.viewModel = viewModel
        genreNameLabel.text = viewModel.genreName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
