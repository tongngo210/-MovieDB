import Foundation

struct MovieReviewTableViewCellViewModel {
    let reviewerName: String
    let movieReviewContent: String
    let reviewerAvatarURLString: String
    let movieReviewRating: Double
    
    init(movieReview: MovieReview) {
        reviewerName = movieReview.reviewerName ?? ""
        movieReviewContent = movieReview.content ?? ""
        reviewerAvatarURLString = movieReview.reviewerInfo?.avatar ?? ""
        movieReviewRating = movieReview.reviewerInfo?.rating ?? 0
    }
}
