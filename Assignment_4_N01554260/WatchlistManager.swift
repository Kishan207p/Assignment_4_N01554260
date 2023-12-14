//
//  WatchlistManager.swift
//  Assignment_4_N01554260
//
//  Created by user235677 on 12/13/23.
//

import Foundation

class WatchlistManager {

    static let shared = WatchlistManager()

    private var watchlist: [MovieModel] = []

    private init() {}

    func getWatchlist() -> [MovieModel] {
        return watchlist
    }

    func addToWatchlist(movie: MovieModel) {
        watchlist.append(movie)
    }

    func removeFromWatchlist(movie: MovieModel) {
        if let index = watchlist.firstIndex(where: { $0.imdbID == movie.imdbID }) {
            watchlist.remove(at: index)
        }
    }

    func isMovieInWatchlist(movie: MovieModel) -> Bool {
         return watchlist.contains { $0.imdbID == movie.imdbID }
     }
}
