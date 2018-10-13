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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let repositoryViewModel = repositoryViewModel else { return }
        switch repositoryViewModel.isStarred {
        case true:
            starButton.titleLabel?.text = "Unstar"
        case false:
            starButton.titleLabel?.text = "Star"
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
        case false:
            self.delegate?.star(repository: repositoryViewModel)
        }
    }
}
