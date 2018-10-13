//
//  DetailViewController.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-08.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var starButton: UIButton!
    @IBAction func starButtonDidTap(_ sender: Any) {
        toggleStarStatus()
    }
    
    weak var delegate: RepositoriesUpdater?
    
    var repositoryViewModel: Repository? {
        didSet{
            updateView()
        }
    }
    
    let style = Style()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let repositoryViewModel = repositoryViewModel else { return }
        switch repositoryViewModel.isStarred {
        case true:
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .starred)
        case false:
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .unstarred)
        }
        
    }
}

fileprivate extension DetailViewController {
    func updateView() {
        self.title = repositoryViewModel?.name
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
