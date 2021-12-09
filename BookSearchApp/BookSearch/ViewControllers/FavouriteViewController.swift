//
//  FavouriteViewController.swift
//  BookSearch
//
//  Created by Simranjeet Kaur on 2021-11-17.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    //MARK: -Properties
    var bookStore: BookStore!
    var favouriteBooks = [Book]()
    
    //MARK: -Outlets
    @IBOutlet weak var favouriteTableView: UITableView!
    
    //MARK: -Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
    }
    //MARK: -Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //convert the set into an array and sort it alphabetically by name
        favouriteBooks = Array(bookStore.favouriteBooks
        ).sorted(by: {$0.trackName < $1.trackName})
        
        //reload the table
        favouriteTableView.reloadData()
        
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destinationVC = segue.destination as? DetailViewController, let indexPath = favouriteTableView.indexPathForSelectedRow else { return }
        
        //pass the site and the sitestore
        destinationVC.book = favouriteBooks[indexPath.row]
        destinationVC.bookStore = bookStore
        
    }
}
//Function to add the books
extension FavouriteViewController: UITableViewDelegate{
    //allow for the deletion of favourite sites
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //remove from the sites array
            let itemToRemove = favouriteBooks[indexPath.row]
            favouriteBooks.remove(at: indexPath.row)
            //remove from the site store
            bookStore.removeFavourites(book: itemToRemove)
            //delete the specific row
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
}
//Function to add data to the tableView
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteBooks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)
        
        let site = favouriteBooks[indexPath.row]
        
        cell.textLabel?.text = site.trackName
        cell.detailTextLabel?.text = site.description
        
        return cell
    }
    
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

