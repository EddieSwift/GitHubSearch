//
//  GitHubTableViewController.swift
//  GitHubSearch
//
//  Created by Eduard Galchenko on 11.11.2020.
//

import UIKit

class GitHubTableViewController: UITableViewController {
    
    private var searchBar: UISearchBar!
    private var repositories = [Repository]()
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var searchBarActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    let semaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        setupMainUI()
        setupActivityIndicator()
    }
    
    // MARK: - Network Method
    
    private func getRepositories(page: Int, searchKey: String) {
        NetworkService.shared.getRepositories(searchRepositoryName: searchKey, page: page) { [weak self] state in
            self?.searchBarActivityIndicator.removeFromSuperview()
            guard let `self` = self else { return }
            switch state {
            case .success(let repositories):
                self.repositories.append(contentsOf: repositories)
                self.semaphore.signal()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error(let error):
                print(error.localizedDescription)
            }
            self.stopAnimation()
            self.hideKeyboard()
        }
        
    }
    
    // MARK: - Setup UI Methods
    
    private func setupMainUI() {
        searchBar = UISearchBar()
        searchBar.addSubview(searchBarActivityIndicator)
        searchBarActivityIndicator.frame = searchBar.bounds
        
        view.addSubview(searchBar)
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search repositories..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = tableView.center
        activityIndicator.color = .blue
    }
    
    // MARK: - Indicator Methods
    
    private func startAnimation() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    // MARK: - Alert metod
    
    private func notFoundRepositoriesAlert() {
        let alert = UIAlertController(title: "Warning",
                                      message: "Repositories were not found. Try again, please.",
                                      preferredStyle: .alert)
        
        let cancleAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
    
}

extension GitHubTableViewController {
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let repository = repositories[indexPath.row]
        
        cell.textLabel?.text = repository.name
        cell.detailTextLabel?.text = "Stars: \(repository.stars)"
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension GitHubTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        repositories.removeAll()
        tableView.reloadData()
        
        setupActivityIndicator()
        
        let firstQueue = DispatchQueue(label: "com.firstQueue", attributes: .concurrent)
        let secondQueue = DispatchQueue(label: "com.secondQueue", attributes: .concurrent)
        
        startAnimation()
        searchBarActivityIndicator.startAnimating()
        
        guard let searchRepositoryName = searchBar.text else { return }
        
        firstQueue.async {
            self.semaphore.wait()
            self.getRepositories(page: 1, searchKey: searchRepositoryName)
        }
        
        secondQueue.async {
            self.semaphore.wait()
            self.getRepositories(page: 2, searchKey: searchRepositoryName)
        }
        
        searchBar.text = nil
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    // MARK: - Help Method
    private func hideKeyboard() {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
