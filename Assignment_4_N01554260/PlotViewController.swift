//
//  PlotViewController.swift
//  Assignment_4_N01554260
//
//  Created by user235677 on 12/13/23.
//

import UIKit

class PlotViewController: UIViewController {

    @IBOutlet weak var ratingsTextView: UITextView!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var addToWatchlistButton: UIButton!

    var movie: MovieModel?
    var ratings: [MovieModel.Rating]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        guard let movie = movie else {
              return
          }

        // Set up the text views
        ratingsTextView.text = formattedRatings()
        plotTextView.text = movie.plot

        // Customize the appearance of addToWatchlistButton
        addToWatchlistButton.layer.cornerRadius = 8
        addToWatchlistButton.layer.borderWidth = 1
        addToWatchlistButton.layer.borderColor = UIColor.systemBlue.cgColor
    }


    @IBAction func addToWatchlistButtonTapped(_ sender: UIButton) {
        
        guard let selectedMovie = movie else {
                return
            }

            if WatchlistManager.shared.isMovieInWatchlist(movie: selectedMovie) {
                // Movie is already in the watchlist
                showPopupAlert(message: "Movie is already in the watchlist.")
            } else {
                // Movie is not in the watchlist, add it
                WatchlistManager.shared.addToWatchlist(movie: selectedMovie)
                showPopupAlert(message: "Added to Watchlist: \(selectedMovie.title ?? "")")
            }
    }
    
    func formattedRatings() -> String {
        guard let ratings = movie?.ratings else {
            return "No ratings available"
        }

        var formattedText = ""
        for rating in ratings {
            if let source = rating.Source, let value = rating.Value {
                formattedText += "\(source): \(value)\n"
            } else {
                // Handle the case where either source or value is nil
            }
        }

        return formattedText.isEmpty ? "No ratings available" : formattedText
    }



        func showPopupAlert(message: String) {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }


