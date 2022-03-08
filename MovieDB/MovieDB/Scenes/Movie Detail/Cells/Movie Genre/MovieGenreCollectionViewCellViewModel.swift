import Foundation

struct MovieGenreCollectionViewCellViewModel {
    let genreName: String
    
    init(genre: Genre) {
        genreName = genre.name
    }
}
