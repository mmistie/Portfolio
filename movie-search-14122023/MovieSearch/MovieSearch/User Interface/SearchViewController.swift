import UIKit

// MARK: - Search View Controller

class SearchViewController: UIViewController, CoordinatedViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var findItButton: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var bannerBackground: UIView!
    @IBOutlet weak var bannerSquashConstraint: NSLayoutConstraint!
    @IBOutlet weak var noResultsView: UIView!

    weak var coordinator: Coordinator?
    var searchCoordinator: SearchCoordinator? {
        return coordinator as? SearchCoordinator
    }

    @IBAction func onTitleEditingDidEnd(_ sender: Any) {
        startSearch()
    }

    @IBAction func onTappedFindIt(_ sender: Any) {
        titleTextField.resignFirstResponder()
        startSearch()
    }

    func startSearch() {
        guard let title = titleTextField.text else {
            return
        }
        searchCoordinator?.performSearch(title: title)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bannerSquashConstraint.priority = .defaultHigh
        bannerLabel.alpha = 0.0
        bannerBackground.alpha = 0.0
    }

}

// MARK: - Coordinated Updates

extension SearchViewController {

    func updateSearchResults() {
        resultsTableView.reloadData()
        noResultsView.alpha = 0.0
        resultsTableView.alpha = 1.0
    }

    func updateNoMoviesFound() {
        resultsTableView.reloadData()
        noResultsView.alpha = 1.0
        resultsTableView.alpha = 0.0
    }

    // Integrate poster images into the UI as they become available.
    func posterBecameAvailable(imdbId: String, posterImage: UIImage) {
        // Determine if any visible cells need the poster (if not the
        // poster will get picked up when any fresh cell is configured).
        resultsTableView.visibleCells.forEach { cell in
            guard
                let movieCell = cell as? MovieTableViewCell,
                movieCell.movie?.imdbId == imdbId
            else {
                return
            }

            movieCell.showPoster(image: posterImage)
        }
    }

}

// MARK: - Error Message Display

extension SearchViewController {
    private static let animationDuration = 0.4

    func showErrorMessage(_ message: String) {
        bannerLabel.text = message
        self.bannerSquashConstraint.priority = .defaultLow
        self.bannerBackground.alpha = 1.0

        UIView.animateKeyframes(
            withDuration: SearchViewController.animationDuration,
            delay: 0.0,
            options: .layoutSubviews
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.5
            ) {
                self.bannerSquashConstraint.priority = .defaultLow
                self.view.layoutIfNeeded()
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5
            ) {
                self.bannerLabel.alpha = 1.0
            }
        }
    }

    func hideErrorMessage() {
        UIView.animateKeyframes(
            withDuration: SearchViewController.animationDuration,
            delay: 0.0,
            options: .layoutSubviews
        ) {
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.5
            ) {
                self.bannerLabel.alpha = 0.0
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5
            ) {
                self.bannerSquashConstraint.priority = .defaultHigh
                self.view.layoutIfNeeded()
                self.bannerBackground.alpha = 0.0
            }
        }
    }

}

// MARK: - Table View Delegate

extension SearchViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard
            let movieCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell,
            let movie = movieCell.movie
        else {
            return
        }

        searchCoordinator?.showDetailScreen(movie: movie)
    }
}

// MARK: - Table View Data Source

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCoordinator?.moviesSearchResultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let movie = searchCoordinator?.movieSearchResult(
                atIndex: indexPath.row
            ),
            let movieCell = tableView.dequeueReusableCell(
                withIdentifier: "MovieTableViewCell",
                for: indexPath
            ) as? MovieTableViewCell
        else {
            fatalError()
        }
        
        movieCell.configure(movie: movie)
        
        if let imdbId = movie.imdbId,
           let posterImage = searchCoordinator?.getPosterImage(imdbId: imdbId)
        {
            movieCell.showPoster(image: posterImage)
        } else {
            movieCell.showPoster(image: nil)
        }
        
        return movieCell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let twoPer = (0.9 * UIScreen.main.bounds.width) / 2
        if twoPer > 324 {
            return 250
        }
        return 324
    }
}

// MARK: - Text Field Delegate

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
