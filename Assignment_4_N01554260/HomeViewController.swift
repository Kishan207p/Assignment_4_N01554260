//
//  HomeViewController.swift
//  Assignment_4_N01554260
//
//  Created by user235677 on 12/12/23.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    // Declare movie at the class level
    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // Hide the image view, labels, and button initially
        posterImageView.isHidden = true
        nameLabel.isHidden = true
        yearLabel.isHidden = true
        moreInfoButton.isHidden = true

        // Set up the navigation bar
        navigationItem.title = "Home"
        let watchlistButton = UIBarButtonItem(image: UIImage(systemName: "list.and.film"), style: .plain, target: self, action: #selector(watchlistButtonTapped))
        navigationItem.rightBarButtonItem = watchlistButton

        // Set UITextField delegate to self
        searchBar.delegate = self

        // Add target action for moreInfoButton
        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonTapped), for: .touchUpInside)
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSearch()
    }

    // UITextFieldDelegate method to handle return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }

    func performSearch() {
        guard let movieName = searchBar.text, !movieName.isEmpty else {
            // Show an alert or handle the case where the text field is empty
            return
        }

        // Make a network request to fetch movie information
        NetworkingManager.shared.searchForMovie(title: movieName) { movie, error in
            if let error = error {
                print("Error: \(error)")
            } else if let movie = movie {
                print("Movie: \(String(describing: movie.title))")

                // Set the movie property
                self.movie = movie

                // Update UI with the movie information
                DispatchQueue.main.async {
                    self.updateUI(with: movie)
                }
            }
        }

        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }

    func updateUI(with movie: MovieModel) {
        // Show the image view, labels, and button
        posterImageView.isHidden = false
        nameLabel.isHidden = false
        yearLabel.isHidden = false
        moreInfoButton.isHidden = false

        // Extract the required information from the movie model
        let title = movie.title ?? "N/A"
        let year = movie.year ?? "N/A"
        let posterURL = movie.poster ?? ""

        // Update UI elements with extracted information
        nameLabel.text = title
        yearLabel.text = year

        // Load the movie poster asynchronously
        if let posterURL = URL(string: posterURL) {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    @objc func moreInfoButtonTapped() {
        // Check if there is a movie object set in your UI
        guard let movie = movie else {
            return
        }

        // Instantiate the DetailViewController
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        // Pass the selected movie to the detail view controller
        detailViewController.movie = movie

        // Push the detail view controller to the navigation stack
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        // Show the watchlist screen
        let watchlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WatchlistViewController") as! WatchlistViewController
        navigationController?.pushViewController(watchlistViewController, animated: true)
    }
}
