//
//  RepositoryViewModelTests.swift
//  GitHubRepositoryTests
//
//  Created by Eman Alsabbagh on 4/17/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import XCTest

@testable import GitHubRepository

class RepositoryViewModelTests: XCTestCase {
    
    var viewModel: RepositoryViewModel!
    var mockGitHubService: MockGitHubService!
    
    override func setUp() {
        super.setUp()
        mockGitHubService = MockGitHubService()
        viewModel = RepositoryViewModel(gitHubService: mockGitHubService)
        
    }
    
    override func tearDown() {
        viewModel = nil
        mockGitHubService = nil
        super.tearDown()
    }
    
    func test_get_repository() {
        // Given
        mockGitHubService.completeRepositories = [Repository]()
        
        // When
        viewModel.loadRepositories(withUsername: "johnsundell", page: 1)
        mockGitHubService.getRepositorySuccess()
        
        // Assert
        XCTAssert(mockGitHubService!.getRepositories)
    }
    
    func test_get_repository_fail() {
        
        // When
        viewModel.loadRepositories(withUsername: "johnsundell", page: 1)
        
        mockGitHubService.getRepositoryFail()
        
        // Sut should display predefined error message
        XCTAssertEqual( viewModel.alertMessage, nil)
    }
    
    
}

class MockGitHubService: GitHubService {
    
    var getRepositories = false
    
    var completeRepositories: [Repository] = [Repository]()
    var getRepositoryResult: GitHubService.GetRepositoryResult?
    
    var completeClosure: ((GitHubService.GetRepositoryResult) -> ())!
    
    
    override func loadRepositories(withUsername username: String, page: Int, completion: @escaping GitHubService.GetRepositoryCompletion) {
        getRepositories = true
        completeClosure = completion
    }
    
    func getRepositorySuccess() {
        completeClosure(.success(payload: completeRepositories))
    }
    
    func getRepositoryFail() {
         completeClosure(.failure(nil))
    }
    
}



