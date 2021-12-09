//
//  BookStore.swift
//  BookSearch
//
//  Created by Simranjeet Kaur on 2021-11-17.
//

import Foundation

class BookStore{
    
    
    //MARK: -Properties
    //Property to store all the books
    var allBooks = [Book]()
    
    //Property to add the favourite books
    var favouriteBooks = Set<Book>()
    
    //A file to store favourite books
    var documentDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //MARK: -Functions
    //Function to add favourite books
    func addToFavourites(book: Book){
        favouriteBooks.insert(book)
        saveFavouriteBook()
    }
    
    
    //Function to delete favourite books
    func removeFavourites(book: Book){
        favouriteBooks.remove(book)
        saveFavouriteBook()
    }
    
    
    //Function to load the favourite books
    func loadFavourites() {
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("site.json")
        print(fileName)
        //file decode JSON
        decodeJSON(from: fileName)
    }
    
    
    //Function to save the favourite books
    func saveFavouriteBook(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("site.json")
        
        //encode the details to JSON
        saveJSON(to: fileName)
    }
    
    
    //Function to decode the data
    func decodeJSON(from url: URL){
        do {
            print("loaded")
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let resultsArray = try decoder.decode([Book].self, from: jsonData)
            
            for trail in resultsArray {
                favouriteBooks.insert(trail)
                print(trail)
            }
            
        } catch {
            print("Could not decode - \(error.localizedDescription)")
        }
    }
    
    
    //Function to save the json data
    func saveJSON(to url: URL) {
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(favouriteBooks)
            try jsonData.write(to: url)
        } catch {
            print("Problem saving the JSON file - \(error.localizedDescription)")
        }
    }
}
