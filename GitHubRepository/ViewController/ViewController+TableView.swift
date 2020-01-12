//
//  ViewController+TableView.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/17/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryTableViewCell
        
        let repository = viewModel.repositories[indexPath.row]
        cell.name?.text = repository.name
        cell.repoDescription?.text = repository.descriptionField
        cell.language?.text = repository.language
        cell.forksCount?.text = "\(repository.forksCount)"
        cell.createdDate?.text = repository.createdAt
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repositories"
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // reach table bottom, request more data
        if indexPath.row == viewModel.repositories.count - 1 && viewModel.isLoading && isConnected {
            
            viewModel.loadRepositories(withUsername: self.userName, page: self.viewModel.page)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        
        // to open the selected repository on safari
        
        if let url = URL(string: repository.htmlURL!) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
}
