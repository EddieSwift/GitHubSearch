//
//  NetworkService.swift
//  GitHubSearch
//
//  Created by Eduard Galchenko on 10.11.2020.
//

import Alamofire
import SwiftyJSON

enum NetworkResponse {
    case success(_ repository: [Repository])
    case error(_ error: Error)
}

public class NetworkService {
    public static let shared = NetworkService()
    func getRepositories(_ apiUrl: String, completion: @escaping (NetworkResponse) -> Void) {
        
        var repositories = [Repository]()
        
        AF.request(Constants.NetworkURL.baseURL + apiUrl + Constants.NetworkURL.restURL).responseJSON { response in
            if response.value != nil {
                let json = JSON(response.value as Any)
                let results = json["items"].arrayValue
                
                for result in results {
                    let repository = Repository(name: result["name"].stringValue, stars: result["stargazers_count"].intValue)
                    repositories.append(repository)
                }
                completion(.success(repositories))
            } else {
                guard let error = response.error else {
                    completion(.error(response.error!))
                    return
                }
                completion(.error(error))
            }
        }
    }
}
