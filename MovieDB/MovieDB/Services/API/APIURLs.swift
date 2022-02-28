import Foundation

enum APIURLs {
    enum Image {
        static let original = "https://image.tmdb.org/t/p/original"
    }
    
    static let scheme = "https"
    static let host = "api.themoviedb.org"
    static let version = "/3"
    private static let movie = version + "/movie"
    static let latestMovies = movie + "/latest"
    static let nowPlayingMovies = movie + "/now_playing"
    static let popularMovies = movie + "/popular"
    static let topRatedMovies = movie + "/top_rated"
    static let upcomingMovies = movie + "/upcoming"
    static let movieDetail = movie + "/%d"
    static let movieReviews = movieDetail + "/reviews"
}
