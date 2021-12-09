//
//  BookTableViewCell.swift
//  BookSearch
//
//  Created by Simranjeet Kaur on 2021-11-17.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    //MARK: - Outlets
    //BookName
    @IBOutlet weak var bookName: UILabel!
    //BookImage
    @IBOutlet weak var bookImage: UIImageView!
    //BookAuthor
    @IBOutlet weak var bookAuthor: UILabel!
    //Book release Date
    @IBOutlet weak var bookReleaseDate: UILabel!
    
    
    //MARK: -Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //MARK: -Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    //Function to load the data to the cell
    func setUpCell(using booksDetail: Book){
        bookName.text = booksDetail.trackName
        bookReleaseDate.text = "Released: \(booksDetail.releaseDate)"
        bookAuthor.text = "Author: \(booksDetail.artistName)"
        //set a default image in case there is no poster
        bookImage.image = UIImage(named: "download.jpg")
        
        //Setting Image
        //get the poster path string
        if let imagePath = booksDetail.artworkUrl100 {
            fetchImage(for: imagePath)
        } else  {
            bookImage.image = UIImage(named: "download.jpg")
        }
    }
        
      
        
    //Function to build a url to fetch the post and load the image
    func fetchImage(for path: String){
    let posterPath = path

    guard let imageUrl = URL(string: posterPath) else {
        return
    }
    let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
        url, response, error in

        if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
            DispatchQueue.main.async {
                self.bookImage.image = image
            }
        }
    }
    imageFetchTask.resume()
}
}
    //Setting Iamgeview
    extension UIImageView {
    func loads(url: URL) {
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

