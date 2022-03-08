import Foundation

struct MovieReviewList: Decodable {
    let id: Int
    let results: [MovieReview]
}

struct MovieReview: Decodable {
    let reviewerName: String?
    let reviewerInfo: ReviewerInfo?
    let content: String?
    
    private enum CodingKeys: String, CodingKey {
        case reviewerName = "author"
        case reviewerInfo = "author_details"
        case content
    }
}

struct ReviewerInfo: Decodable {
    let avatar: String?
    let rating: Double?
    
    private enum CodingKeys: String, CodingKey {
        case avatar = "avatar_path"
        case rating
    }
}
