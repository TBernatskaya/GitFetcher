//
//  SearchResultTableViewCell.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 14)
        return lbl
    }()

    let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        lbl.numberOfLines = 3
        return lbl
    }()

    let urlLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 11)
        return lbl
    }()

    let starStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        return lbl
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.nameLabel,
                                                       self.descriptionLabel,
                                                       self.urlLabel,
                                                       self.starStatusLabel])
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.autoresizingMask = [.flexibleWidth]
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        descriptionLabel.text = ""
        urlLabel.text = ""
        starStatusLabel.text = ""
    }
}
