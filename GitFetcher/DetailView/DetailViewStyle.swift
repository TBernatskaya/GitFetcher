//
//  DetailViewStyle.swift
//  GitFetcher
//
//  Created by Tatiana Bernatskaya on 2018-10-13.
//  Copyright © 2018 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

extension DetailViewController {
    
    enum StarButtonState {
        case starred
        case unstarred
    }
    
    struct Style {
        func starBackgroundColor(for state: StarButtonState) -> UIColor {
            switch state {
            case .starred:
                return .yellow
            case .unstarred:
                return .gray
            }
        }
    }
}
