//
//  SearchResultTableViewCell.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var starStatusLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        descriptionLabel.text = ""
        urlLabel.text = ""
        starStatusLabel.text = ""
    }
}
