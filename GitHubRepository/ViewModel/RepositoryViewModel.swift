//
//  RepositoryViewModel.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/11/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class RepositoryViewModel {
    
    ///closure use for notifi
    var reloadList = {() -> () in }
    
    var repositories : [Repository] = []{
        ///Reload repositories when data set
        didSet{
            reloadList()
        }
    }
    
    var reloadHeader = {() -> () in }
    
    var owner: Owner! {
        ///Reload owner when data set
        didSet{
            reloadHeader()
        }
    }
    
    // for pagination
    var page = 1
    var isLoading = true
    
    // for API Service
    let gitHubService: GitHubService
    
    // Database Service
    let database: CoreDataService
    
    // to show Alert with errors
    var showAlertClosure: (()->())?
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    
    init(gitHubService: GitHubService = GitHubService(), database: CoreDataService = CoreDataService()) {
        self.gitHubService = gitHubService
        self.database = database
    }
    
    
    ///get Repositories from api
    func loadRepositories(withUsername username: String, page: Int)
    {
        gitHubService.loadRepositories(withUsername: username, page: page, completion: { [weak self] result in
            
            switch result {
            case .success(let repositories):
                guard repositories.count > 0 else {
                    self?.isLoading = false
                    return
                }
                self?.repositories += repositories
                self?.page = page + 1
                self?.isLoading = true
                
                //context save
                self?.database.saveContext()
                
            case .failure(let error):
                self?.isLoading = false
                self?.alertMessage = error?.rawValue
            }
        })
        
        
    }
    
    ///get Owner from api
    func loadOwner(withUsername username: String)  {
        
        gitHubService.loadOwner(withUsername: username, completion: { [weak self] result in
            
            switch result {
            case .success(let owner):
                self?.owner = owner
                
                //context save
                self?.database.saveContext()
                
            case .failure(let error):
                self?.alertMessage = error?.rawValue
            }
        })
        
        
    }
    
    
    // Local data fetch from core data
    func fetchRepositoryFromLocal()  {
        self.repositories += database.fetchRepositories()
    }
    
    // Local data fetch from core data
    func fetchOwnerFromLocal()  {
        self.owner = database.fetchOwner()
    }
    
    
}


