//
//  Poster.swift
//  MovieSearch
//
//  Created by user235795 on 08/12/2023.
//

import Foundation

// MARK: - Poster

class Poster: Codable {
    let imdbId: String
    let imageData: Data

    init(imdbId: String, imageData: Data) {
        self.imdbId = imdbId
        self.imageData = imageData
    }
}
