//
//  PostCell.swift
//  Recipes-App
//
//  Created by Omar Muniz on 11/29/22.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedPhotoView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    
    @IBOutlet weak var bookMarkIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
