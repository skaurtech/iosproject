//
//  DetailViewController.swift
//  BookSearch
//
//  Created by Simranjeet Kaur on 2021-11-17.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Properties
    var book: Book!
    var bookStore: BookStore!
   // var bookStore =  BookStore()
    
    //MARK: - Outlets
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var decriptionLabel: UILabel!
    //@IBAction func savebutton(_ sender: Any) {
    
    @IBOutlet weak var addNotes: UITextField!
    //Button to save the books to favourite view controller
    @IBAction func addFavouritesButton(_ sender: Any) {
    
        //check to see if the site is already a favourite
        if bookStore.favouriteBooks.contains(book){
            //it already is so remove it and update the button image
            bookStore.removeFavourites(book: book)
            //Alert
            let alertController = UIAlertController(title: "Removed", message: "Removed From Favourites!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))

                self.present(alertController, animated: true, completion: nil)
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            //it is not - add it as a favourite and update the button image
            print(bookStore.addToFavourites(book: book))
            bookStore.addToFavourites(book: book)
            //Alert
            let alertControllers = UIAlertController(title: "Added", message: "Added to Favourites!", preferredStyle: .alert)
                alertControllers.addAction(UIAlertAction(title: "OK", style: .default))

                self.present(alertControllers, animated: true, completion: nil)
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
        
    }
    
    //MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Setting the data to the details table
        if let book = book {
            bookTitle.text =  book.trackName

            decriptionLabel.text = book.description
            
            //Image
            if let imagePath = book.artworkUrl100 {
                fetchImage(for: imagePath)
            } else  {
                imageView.image = UIImage(named: "download.jpg")
            }
            
        }
        
        //MARK: - Gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(DetailViewController.dismissKeyboard))

           view.addGestureRecognizer(tap)
        
    }
    //function to dismiss the keyboard
    @objc func dismissKeyboard() {
        self.addNotes.resignFirstResponder()
    }
    //MARK: - Function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set the image in the button bar based on whether this is considered a favourite site
        if bookStore.favouriteBooks.contains(book){
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }
    
    
    //Function to fetch the image
    func fetchImage(for path: String){
        let posterPath = path

        guard let imageUrl = URL(string: posterPath) else {
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in

            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        imageFetchTask.resume()
    }
    
    }
    //imageView
        extension UIImageView {
        func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
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

