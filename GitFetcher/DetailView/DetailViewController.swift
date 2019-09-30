//
//  DetailViewController.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-08.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    lazy var errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 14)
        return lbl
    }()

    let forkLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        return lbl
    }()

    let urlLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 11)
        return lbl
    }()

    let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13)
        lbl.numberOfLines = 3
        return lbl
    }()

    let starButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggleStarStatus), for: .touchUpInside)
        btn.setImage(UIImage(named: "star72Darkblue"), for: .normal)
        return btn
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.starButton,
                                                       self.errorLabel,
                                                       self.forkLabel,
                                                       self.urlLabel,
                                                       self.descriptionLabel
                                                       ])
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    weak var delegate: RepositoriesUpdater?
    let style = Style()

    var repositoryViewModel: Repository? {
        didSet{
            self.title = repositoryViewModel?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        updateLayout()
    }

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
        errorLabel.isHidden = true
        
        switch repositoryViewModel.isStarred {
        case true:
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .starred)
        case false:
            starButton.imageView?.backgroundColor = style.starBackgroundColor(for: .unstarred)
        }
    }

    func updateLayout() {
        var topPadding: CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 0
        var bottomPadding: CGFloat = 16

        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow
                else { return }
            topPadding += window.safeAreaInsets.top
            bottomPadding = window.safeAreaInsets.bottom
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16 + topPadding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: bottomPadding),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
        ])
    }
    
    @objc func toggleStarStatus() {
        guard let repositoryViewModel = repositoryViewModel else { return }
        
        switch repositoryViewModel.isStarred {
        case true:
            self.delegate?.unstar(repository: repositoryViewModel, completion: { [weak self] error in
                guard let weakSelf = self else { return }
                
                if let error = error {
                    weakSelf.showTextMessage(with: error.localizedDescription)
                } else {
                    weakSelf.starButton.imageView?.backgroundColor = weakSelf.style.starBackgroundColor(for: .unstarred)
                }
            })
           
        case false:
            self.delegate?.star(repository: repositoryViewModel, completion: { [weak self] error in
                guard let weakSelf = self else { return }
                
                if let error = error {
                    weakSelf.showTextMessage(with: error.localizedDescription)
                } else {
                    weakSelf.starButton.imageView?.backgroundColor = weakSelf.style.starBackgroundColor(for: .starred)
                }
            })
        }
    }
    
    func showTextMessage(with text: String) {
        errorLabel.text = text
        errorLabel.isHidden = false
    }
}
