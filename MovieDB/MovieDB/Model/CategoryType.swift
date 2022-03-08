import Foundation

enum CategoryType: CaseIterable {
    case nowPlaying
    case popular
    case upcoming
    case topRated
    
    var url: String {
        switch self {
        case .nowPlaying:
            return APIURLs.nowPlayingMovies
        case .popular:
            return APIURLs.popularMovies
        case .upcoming:
            return APIURLs.upcomingMovies
        case .topRated:
            return APIURLs.topRatedMovies
        }
    }
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        }
    }
}
