//
//  DetailViewController.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-08.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

protocol RepositoryActionLisener: class {
    func starStatusDidchange(to newStatus: StarStatus)
}

enum StarStatus {
    case starred
    case unstarred
}

class DetailViewController: UIViewController {
    
    @IBAction func starButtonDidTap(_ sender: Any) {
        toggleStarStatus()
    }
    
    weak var delegate: RepositoryActionLisener?
    
    var repositoryViewModel: Repository? {
        didSet{
            updateView()
        }
    }
}

fileprivate extension DetailViewController {
    func updateView() {
        self.title = repositoryViewModel?.name
    }
    
    func toggleStarStatus() {
        
    }
}
