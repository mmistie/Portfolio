//
//  MovieCollectionViewCell.swift
//  MovieSearch
//
//  Created by user235795 on 08/12/2023.
//

import UIKit

// MARK: - Movie Collection View Cell

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    var movie: Movie?

}

// MARK: - Cell Configuration

extension MovieTableViewCell {

    func configure(movie: Movie) {
        self.movie = movie

        titleLabel.text = movie.title

        if let year = movie.year {
            yearLabel.text = "(\(year))"
        } else {
            yearLabel.text = nil
        }

        if !movie.hasPoster {
            showPoster(image: nil)
        }
    }

    func showPoster(image: UIImage?) {
        posterImageView.backgroundColor = UIColor(named: "MovieCellBackground")

        if image == nil {
            posterImageView.tintColor = UIColor(named: "Title")
            posterImageView.image = UIImage(systemName: "video")
            posterImageView.alpha = 0.05
        } else {
            posterImageView.image = image
            posterImageView.alpha = 1.0
        }
    }
}
