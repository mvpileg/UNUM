//
//  BreedsTableViewCell.swift
//  UNUM
//
//  Created by Matthew Pileggi on 4/11/18.
//  Copyright © 2018 Matthew Pileggi. All rights reserved.
//

import UIKit

class BreedsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var breedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        breedImage.layer.cornerRadius = 5
        breedImage.clipsToBounds = true
    }
    
    func load(name: String, image: UIImage?) {
        breedName.text = name
        breedImage.image = image
    }
    
}
