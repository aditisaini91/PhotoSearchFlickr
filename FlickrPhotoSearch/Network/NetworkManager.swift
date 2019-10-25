//
//  NetworkManager.swift
//  FlickrPhotoSearch
//
import UIKit

let apiKey = "bfca6e5a10883bb006a3389a7feee34a"     //Needs to updated from https://www.flickr.com/services/api/explore/flickr.photos.search
var searchTag = "kittens"
let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(searchTag)&per_page=20&format=json&nojsoncallback=1"


class NetworkManager {
    func searchFlickr(for searchTerm: String, completion: @escaping ([Photo]) -> Void) {
        searchTag = searchTerm;
        
        guard let searchURL = URL(string: URLString) else {
            print("Url error")
            return
        }
        let urlRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("URLSession \(error)")
                return
            }
            
            guard
                let _ = response as? HTTPURLResponse,
                let data = data
                else {
                    print("Unknown api response : Invalid data")
                    return
            }
            
            do {
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let status = resultsDictionary["stat"] as? String
                    else {
                        print("Unknown api response : No status")
                        return
                }
                
                switch (status) {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    print("Results processed failed")
                    return
                default:
                    print("Results processeing issue")
                    return
                }
                
                guard
                    let response = resultsDictionary["photos"] as? [String: AnyObject],
                    let photosResponse = response["photo"] as? [[String: AnyObject]]
                    else {
                        print("Unknown api issue , processing photos")
                        return
                }
                
                let flickrSearchPhotos: [Photo] = photosResponse.compactMap { obj in
                    guard
                        let photoID = obj["id"] as? String,
                        let farm = obj["farm"] as? Int ,
                        let server = obj["server"] as? String ,
                        let secret = obj["secret"] as? String ,
                        let title = obj["title"] as? String
                        
                        else {
                            return nil
                    }
                    
                    var flickrPhoto = Photo(photoID: photoID, farm: farm, server: server, secret: secret, title : title)
                    
                    guard
                        let url = flickrPhoto.imageURL(),
                        let imageData = try? Data(contentsOf: url as URL)
                        else {
                            return nil
                    }
                    
                    if let image = UIImage(data: imageData) {
                        flickrPhoto.image = image
                        return flickrPhoto
                    } else {
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    completion(flickrSearchPhotos)
                }
            } catch {
                print("Exception in NetworkManager searchFlickr : \(error)")
                return
            }
        }.resume()
        
    }
}


