//
//  MainViewController.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-09-19.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchResultsTableViewBottom: NSLayoutConstraint!
    
    lazy var detailViewController: DetailViewController = {
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        return detailViewController
    }()
    
    var repositoriesViewModel: RepositoriesViewModel? {
        didSet {
            repositoriesViewModel?.delegate = self
        }
    }
    
    let starredRepositoriesCache = StarredRepositoriesCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        registerClasses()

        starredRepositoriesCache.fetchStarredRepositories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func clearView() {
        repositoriesViewModel = nil
        searchResultsTableView.isHidden = true
    }
    
    func presentDetails(for repository: Repository) {
        detailViewController.repositoryViewModel = repository
        detailViewController.delegate = repositoriesViewModel
        self.navigationController?.show(detailViewController, sender: self)
    }
}

fileprivate extension MainViewController {
    
    func showSearchResults() {
        errorLabel.isHidden = true
        searchResultsTableView.isHidden = false
        searchResultsTableView.reloadData()
    }
    
    func showTextMessage() {
        searchResultsTableView.isHidden = true
        errorLabel.isHidden = false
    }
    
    func registerClasses() {
        let cellReuseIdentifier = "searchResultCell"
        let cellNib = UINib.init(nibName: "SearchResultTableViewCell", bundle: Bundle.main)
        searchResultsTableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeigt = keyboardFrame.height
        
        searchResultsTableViewBottom.constant = keyboardHeigt
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        searchResultsTableViewBottom.constant = 20
    }
}


extension MainViewController: RepositoriesUpdateListener {
    
    func didUpdateRepositories() {
        guard
            let repositoriesViewModel = repositoriesViewModel,
            let repositories = repositoriesViewModel.repositories,
            repositories.count > 0
            
        else { return showTextMessage() }
        
        showSearchResults()
    }
    
    func didReceive(error: Error) {
        self.searchResultsTableView.isHidden = true
        self.errorLabel.text = error.localizedDescription
        self.errorLabel.isHidden = false
    }
}
