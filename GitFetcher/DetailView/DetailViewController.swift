//
//  DetailViewController.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-08.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBAction func starButtonDidTap(_ sender: Any) {
        toggleStarStatus()
    }
    
    weak var delegate: RepositoriesUpdater?
    
    var repositoryViewModel: Repository? {
        didSet{
            self.title = repositoryViewModel?.name
        }
    }
    
    let style = Style()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
}

fileprivate extension DetailViewController {
    func updateView() {
        guard let repositoryViewModel = repositoryViewModel else { return }
        
        forkLabel.text = repositoryViewModel.isFork ? "Forked" : "Not a fork"
        urlLabel.text = repositoryViewModel.url.absoluteString
        descriptionLabel.text = repositoryViewModel.description
        
        switch repositoryViewModel.isStarred {
        case true:
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .starred)
        case false:
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .unstarred)
        }
    }
    
    func toggleStarStatus() {
        guard let repositoryViewModel = repositoryViewModel else { return }
        
        switch repositoryViewModel.isStarred {
        case true:
            self.delegate?.unstar(repository: repositoryViewModel)
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .unstarred)
        case false:
            self.delegate?.star(repository: repositoryViewModel)
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .starred)
        }
    }
}
