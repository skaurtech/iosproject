//
//  ViewController.swift
//  BookSearch
//
//  Created by Simranjeet Kaur on 2021-11-17.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    //var bookResults = [Book]()
    var bookStore: BookStore!
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    //MARK: - Functions
        //Function to create the url from api
    func createBooksURL(from book: String) -> URL? {
        guard let cleanURl = book.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            fatalError("Can't make a url from :\(book)")
        }
          
        //implementing the APi
        var urlString = "https://itunes.apple.com/search?"
        urlString = urlString.appending("term=\(cleanURl)")
     
        urlString = urlString.appending("&entity=ebook")
        print(urlString)
        return URL(string: urlString)
        
    }
    //MARK: -FETCHDATA
    //Function to fetch the data
    func fetchData(from url: URL, for searchString: String) {
        let booksTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let dataError = error {
                print("Could not fetch data: \(dataError.localizedDescription)")
            } else {
                do{
                guard let someData = data  else {
                    return
                }
                    
                    //Json decoding
                let jsonDecoder = JSONDecoder()
                let downloadResults = try jsonDecoder.decode(Books.self ,from: someData)
                    self .bookStore.allBooks = downloadResults.results
                
            }
                catch let error {
                print("Problem in decoding: \(error.localizedDescription)")
            }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
        }
    }
        booksTask.resume()

}
    
    //Function to fetch the image
    func fetchImage(for path: String, in cell: DetailViewController){

        let posterPath = path

        guard let imageUrl = URL(string: posterPath) else {
            return
        }
        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in

            if error == nil, let url = url, let data = try? Data(contentsOf: url),
                let _ = UIImage(data: data){
                DispatchQueue.main.async {
                    //cell.image = image
                }
            }
        }
        imageFetchTask.resume()
    }
    
    //to change the data as per need
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        
        let selectedBook = bookStore.allBooks[selectedIndex.row]
        
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.bookStore = bookStore
    
        destinationVC.book = selectedBook
    }
    
    //Function to load the tableView with Animations
    func tableView( _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 1.0){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}

extension ViewController: UITableViewDelegate{
    
}
//to change the data of table
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookStore.allBooks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
       // cell.backgroundColor = .systemGray
        
        cell.layer.cornerRadius = 8.0
        let detailBook = bookStore.allBooks[indexPath.row]
        cell.setUpCell(using: detailBook)

        return cell
    }
   
    //to show the number of results
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(bookStore.allBooks.count) results found."
    }

//MARK: -Gesture
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
}
//for the search bar
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard  let searchText = searchBar.text else {
            return
        }
        //user search change with our API
        if let bookUrl = createBooksURL(from: searchText) {
            fetchData(from: bookUrl, for: searchText)
         
        }
        
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }

}

