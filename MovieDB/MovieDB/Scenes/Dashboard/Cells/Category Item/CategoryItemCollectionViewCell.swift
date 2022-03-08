import UIKit
import Reusable

final class CategoryItemCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var categoryLabel: UILabel!
    
    var viewModel: CategoryItemCollectionViewCellViewModel! {
        didSet {
            categoryLabel.text = viewModel.title
        }
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? updateUIWhenCellIsSelected() : updateUIWhenCellIsUnselected()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUIWhenCellIsUnselected()
    }

    private func updateUIWhenCellIsSelected() {
        categoryLabel.do {
            $0.backgroundColor = AppColor.puertoRico
            $0.font = UIFont.setPoppinsFont(style: .poppinsSemiBold, size: .twelve)
            $0.textColor = AppColor.charade
        }
    }
    private func updateUIWhenCellIsUnselected() {
        categoryLabel.do {
            $0.backgroundColor = AppColor.brightGray
            $0.font = UIFont.setPoppinsFont(style: .poppinsRegular, size: .twelve)
            $0.textColor = AppColor.gallery
        }
    }
}
