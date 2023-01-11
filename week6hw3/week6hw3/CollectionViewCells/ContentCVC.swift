//
//  ContentCVC.swift
//  week6hw3
//
//  Created by Melih Cüneyter on 11.01.2023.
//

import UIKit
import Kingfisher

class ContentCVC: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with imageURL: String, content: String) {
        imageView.kf.setImage(with: URL.init(string: imageURL))
        contentLabel.text = content
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ContentCVC", bundle: nil)
    }
}
