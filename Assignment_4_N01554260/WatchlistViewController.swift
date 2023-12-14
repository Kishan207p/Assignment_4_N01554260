//
//  WatchlistViewController.swift
//  Assignment_4_N01554260
//
//  Created by user235677 on 12/13/23.
//


import UIKit

class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var watchlistTableView: UITableView!

    // Use WatchlistManager to manage the watchlist
    var watchlist: [MovieModel] {
        return WatchlistManager.shared.getWatchlist()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the desired height for the cell
        return 150 // Adjust this value according to your preference
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistCell", for: indexPath)

        let movie = watchlist[indexPath.row]

        // Configure the cell with movie information
        cell.textLabel?.text = movie.title

        // Load the movie poster asynchronously
        if let posterURL = URL(string: movie.poster ?? "") {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        // Set a larger size for the image view
//                        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 200, height: 250)
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout() // Ensure the image is displayed correctly
                    }
                }
            }.resume()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = watchlist[indexPath.row]

        // Instantiate the DetailViewController
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        // Pass the selected movie to the detail view controller
        detailViewController.movie = selectedMovie

        // Push the detail view controller to the navigation stack
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the movie from the watchlist and update the table view
            let removedMovie = watchlist[indexPath.row]
            WatchlistManager.shared.removeFromWatchlist(movie: removedMovie)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
