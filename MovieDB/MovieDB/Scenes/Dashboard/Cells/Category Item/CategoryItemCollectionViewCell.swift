import UIKit
import Reusable

fileprivate enum ConstantCategoryItemCollectionCell {
    static let fontSizeCategoryTitle = CGFloat(12)
}

final class CategoryItemCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var categoryLabel: UILabel!
    
    var viewModel: CategoryItemCollectionViewCellViewModel! {
        didSet {
            categoryLabel.text = viewModel.title
        }
    }
    
    override var isSelected: Bool {
        didSet {
            categoryLabel.do {
                if isSelected {
                    $0.backgroundColor = AppColor.puertoRico
                    $0.font = UIFont(name: AppFont.poppinsSemiBold,
                                     size: ConstantCategoryItemCollectionCell.fontSizeCategoryTitle)
                    $0.textColor = AppColor.charade
                } else {
                    configCell()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    private func configCell() {
        categoryLabel.do {
            $0.backgroundColor = AppColor.brightGray
            $0.font = UIFont(name: AppFont.poppinsRegular,
                             size: ConstantCategoryItemCollectionCell.fontSizeCategoryTitle)
            $0.textColor = AppColor.gallery
        }
    }
}
