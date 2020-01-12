//
//  CoreDataTests.swift
//  GitHubRepositoryTests
//
//  Created by Eman Alsabbagh on 4/18/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import XCTest
import CoreData

@testable import GitHubRepository

class CoreDataTests: XCTestCase {
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "GitHubRepository", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
   
   
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    
    var sut: CoreDataService?
    
    override func setUp() {
        super.setUp()
        
        sut = CoreDataService(container: mockPersistantContainer)
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_fetch_all_repository() {
        
        // fetch all repositories
        let results = sut?.fetchRepositories()
        
        //Assert Not equal 0
        XCTAssertNotEqual(results?.count, 0)
        
    }
    
    func test_remove_repository() {
        
        //When remove all
        sut?.deleteAllData("Repository")
        
        //count items
        let items = sut?.fetchRepositories()
        
        //Assert number of item 0
        XCTAssertEqual(items?.count, 0)
        
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Repository")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
}
