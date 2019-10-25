//
//  DetailViewController.swift
//  FlickrPhotoSearch
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var photo : Photo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        _setupView()
    }
    
    func _setupView() {
        if let photo = photo{
            self.titleLabel.text = photo.title
            self.imageView.image = photo.image
        }
    }
    
}
