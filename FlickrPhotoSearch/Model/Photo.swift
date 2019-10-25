//
//  Photo.swift
//  FlickrPhotoSearch
//
import UIKit

struct Photo {
    var photoID: String
    var image: UIImage
    let farm: Int
    let server: String
    let secret: String
    let title : String
    
    init (photoID: String, farm: Int, server: String, secret: String, title: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
        self.title = title
        self.image = UIImage()
    }
    
    func imageURL() -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_m.jpg") {
            return url
        }
        return nil
    }
}

