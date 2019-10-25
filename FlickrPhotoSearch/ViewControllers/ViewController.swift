//
//  ViewController.swift
//  FlickrPhotoSearch
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet  private weak var photoCollectionView: UICollectionView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private let networkManager : NetworkManager = NetworkManager()
    private let reuseIdentifier = "PhotoCell"
    private let detailViewSegueIDentifier : String = "showDetail"
    private var photos: [Photo] = []    //datsource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.register(UINib(nibName:reuseIdentifier, bundle: nil), forCellWithReuseIdentifier:reuseIdentifier)
        
        //TODO : this could be done on textfieldevent
        networkManager.searchFlickr(for: "kittens") { photoResults in
            self.photos = photoResults
            self.photoCollectionView.reloadData()
        }
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        
        let photo : Photo = photos[indexPath.row]
        cell.imageView.image = photo.image
        cell.titleLabel.text = photo.title
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: detailViewSegueIDentifier, sender: indexPath)
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == detailViewSegueIDentifier{
            guard let selectedIndexPath = sender as? IndexPath else {
                return
            }
            guard let vc = segue.destination as? DetailViewController else {
                return
            }
            vc.photo = photos[selectedIndexPath.row]
        }
    }
}

