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
    @IBOutlet weak var numberOfWatchersLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        descriptionLabel.text = ""
        numberOfWatchersLabel.text = ""
        urlLabel.text = ""
    }
}
