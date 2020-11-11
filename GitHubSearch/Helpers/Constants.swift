//
//  Constants.swift
//  GitHubSearch
//
//  Created by Eduard Galchenko on 10.11.2020.
//

import UIKit

public struct Constants {
    
    static let rowHeight: CGFloat = 60.0
    
    public struct NetworkURL {
        static let baseURL = "https://api.github.com/search/repositories?q="
        static let restURL = "&per_page=15&sort=stars&order=desc"
    }
}

// https://api.github.com/search/repositories?q=swiftui&per_page=15&sort=stars&order=desc

// https://api.github.com/search/repositories&q=swiftui&per_page=100

// https://api.github.com/search/repositories?q=swiftui&per_page=10&sort=stars&order=desc

// https://api.github.com/search/repositories?q=swiftui&per_page=10,sort,order}

//     "repository_search_url": "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}",
