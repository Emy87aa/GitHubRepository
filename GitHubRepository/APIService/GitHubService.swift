//
//  GitHubService.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/16/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import Foundation
import CoreData

enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}


class GitHubService {
    
    let baseURL = "https://api.github.com/users/"
    
    let decoder = JSONDecoder()
    
    typealias GetRepositoryResult = Result<[Repository], GetDataFailureReason>
    typealias GetRepositoryCompletion = (_ result: GetRepositoryResult) -> Void

    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
        guard let codableContext = CodingUserInfoKey.init(rawValue: "context") else {
            fatalError("Failed context")
        }
        decoder.userInfo[codableContext] = manageObjContext
    }
    
    
    ///get Repositories from api
    func loadRepositories(withUsername username: String, page: Int, completion: @escaping GetRepositoryCompletion)  {
        
        guard let listURL = URL(string: baseURL + username + "/repos?" + "page=" + "\(page)" + "&per_page=15") else { return }
        
        
        self.session.dataTask(with: listURL) {
            (data,response,error) in
            guard let jsonData = data else {
                completion(.failure(nil))
                return
            }
            
            DispatchQueue.main.async {
                do {
                    // Parse JSON data
                    let repositories = try self.decoder.decode([Repository].self, from: jsonData)
                    
                    completion(.success(payload: repositories))
                    
                } catch let error {
                    print("ParseRepositoryError ->\(error.localizedDescription)")
                    completion(.failure(nil))
                }
            }
            
        }.resume()
    }
    
    
    typealias GetOwnerResult = Result<Owner, GetDataFailureReason>
    typealias GetOwnerCompletion = (_ result: GetOwnerResult) -> Void
    
    ///get Owner from api
    func loadOwner(withUsername username: String, completion: @escaping GetOwnerCompletion)  {
        
        guard let listURL = URL(string: baseURL + username) else { return }
       
        self.session.dataTask(with: listURL){
            (data,response,error) in
            guard let jsonData = data else {
                completion(.failure(nil))
                return
            }
            
            DispatchQueue.main.async {
                do {
                    
                    // Parse JSON data
                    let owner = try self.decoder.decode(Owner.self, from: jsonData)
                    
                    completion(.success(payload: owner))
                    
                } catch let error {
                    print("ParseOwnerError ->\(error.localizedDescription)")
                    completion(.failure(nil))
                }
            }
           
            }.resume()
    }
    
   
}


//enum GetDataFailureReason: Int, Error {
//    case unAuthorized = 401
//    case notFound = 404
//}

enum GetDataFailureReason: String, Error {
    case unAuthorized = "401 unAuthorized"
    case notFound = "404 notFound"
}




