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
        static let pageURL = "&per_page=15&page="
        static let orderURL = "&sort=stars&order=desc"
    }
}
