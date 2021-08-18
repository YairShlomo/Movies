//
//  Movie.swift
//  Movies
//
//  Created by Yair Shlomo on 18/08/2021.
//

import Foundation

struct Movie : Codable {
    let title: String
    let overview : String
    var fav : Bool = false

    init(title: String, overview: String) {
        self.title = title
        self.overview = overview
    }
}
