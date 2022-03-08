import Foundation

struct CategoryItemCollectionViewCellViewModel {
    let title: String
    
    init(category: CategoryType) {
        title = category.title
    }
}
