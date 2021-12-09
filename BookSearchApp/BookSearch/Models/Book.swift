//
//  Book.swift
//  BookSearch
//
//  Created by Simranjeet Kaur on 2021-11-17.
//

import Foundation

//Struct
struct Books: Codable{
    var results: [Book]
}

//Properties of Api
struct Book: Codable, Hashable {
        var trackName: String
        var description: String
        var releaseDate: String
        var artistName: String
        var artworkUrl100: String?
        var artworkUrl60 : String?
}
