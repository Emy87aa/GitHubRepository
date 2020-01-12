//
//  CoreDataService.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/17/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

 var manageObjContext = appDelegate.persistentContainer.viewContext

class CoreDataService
{
    let persistentContainer: NSPersistentContainer!
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    
    func saveContext(){
        
        ///context save
        do {
           try manageObjContext.save()
        } catch let error {
            print("SaveContextError ->",error)
        }
        
    }
    
    

    // Local data fetch from core data
    func fetchRepositories() -> [Repository]  {
        
        var repositories = [Repository]()
        
        manageObjContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Repository")
        request.returnsObjectsAsFaults = false
        
        do {
            repositories += try manageObjContext.fetch(request) as! [Repository]
            
        } catch let error {
            print("FetchRepositoryError ->",error)
        }
        
        return repositories
        
    }
    
    // Local data fetch from core data
    func fetchOwner() -> Owner {
        
        var owner: Owner!
        manageObjContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Owner")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let owners = try manageObjContext.fetch(request) as! [Owner]
            
            owner = owners[0] as Owner
            
        } catch let error {
            print("FetchOwnerError ->", error)
        }
        
        return owner
        
    }
    
    // To delete old saved data
    func deleteAllData(_ entity:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try manageObjContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                manageObjContext.delete(objectData)
            }
        } catch let error {
            print("Detele\(entity)Error ->", error)
        }
    }
    
    // To check if data Exists
    func isDataFetched(_ entity:String) -> Bool {
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let count  = try manageObjContext.count(for: fetchRequest)
            return count == 0 ? false : true
        } catch {
            return false
        }
    }
    
    
}
