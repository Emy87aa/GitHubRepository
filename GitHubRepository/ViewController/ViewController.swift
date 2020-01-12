//
//  ViewController.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/11/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: OwnerHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tasks = [URLSessionDataTask]()
    var userName: String = ""
    
    // view model object
    let viewModel = RepositoryViewModel()
    
    // for pagination
    var page = 1
    var isConnected = false

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        
        viewModel.reloadList = { [weak self] ()  in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.reloadHeader = { [weak self] ()  in
            DispatchQueue.main.async {
                self?.headerView.configure(with: (self?.viewModel.owner)!)
            }
        }
        
        // To show Error messages from API
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(forTitle:"Error", message: message)
                }
            }
        }
        
        
        setupSearchBar()
        
        // check if data fetched to local
        let isRepositoryFetched = viewModel.database.isDataFetched("Repository")
        let isOwnerFetched = viewModel.database.isDataFetched("Owner")
        
        if (isRepositoryFetched && isOwnerFetched){
            // Get data from local
            viewModel.fetchRepositoryFromLocal()
            viewModel.fetchOwnerFromLocal()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
    }
    
    func loadData(withUsername username: String) {
        
        // Check the network connection
        if Reachability.isConnectedToNetwork() {
            // connection available
            isConnected = true
            viewModel.isLoading = true
            
            viewModel.loadRepositories(withUsername: username, page: viewModel.page)
            viewModel.loadOwner(withUsername: username)
        }else{
            // connection not available
            isConnected = false
            viewModel.isLoading = false
            
            self.showAlert(forTitle:"No Network Connection", message: "Please Check the Network Connection & Try Again")
        }
        
    }
    
    func showAlert(forTitle title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
        }))
        self.present(alert, animated: true)
    }
    

}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count > 0 else { return }
        tasks.forEach { $0.cancel() }
        userName = query
        
        // remove old local data
        viewModel.database.deleteAllData("Repository")
        viewModel.database.deleteAllData("Owner")
        viewModel.repositories.removeAll()
        
        // reset page
        viewModel.page = 1
        
        loadData(withUsername: query)
        searchBar.resignFirstResponder()
    }
    
}

