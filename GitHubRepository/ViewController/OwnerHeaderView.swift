//
//  OwnerHeaderView.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/11/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import UIKit

class OwnerHeaderView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    var imageRequest: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupImageView()
    }
    
    func setupImageView() {
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
    
    func reset() {
        imageRequest?.cancel()
        imageRequest = nil
    }
    
    func configure(with owner: Owner) {
        nameLabel.text = owner.name
        blogLabel.text = owner.blog
        loadImage(for: owner)
    }
    
    func loadImage(for owner: Owner) {
        self.imageView.dowloadFromServer(link: owner.avatarURL, contentMode: .scaleAspectFill)
    }
    
}


extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}

