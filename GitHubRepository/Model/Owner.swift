//
//  Owner.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/11/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import Foundation
import CoreData

//typealias Repositories = [Repository]

class Owner: NSManagedObject, Codable {
    
    @NSManaged var name: String!
    @NSManaged var id: Int64
    @NSManaged var nodeID: String!
    @NSManaged var avatarURL: String!
    @NSManaged var blog: String!
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case blog
    }
    
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        
        guard let codableContext = CodingUserInfoKey.init(rawValue: "context"),
            let managedObjectContext = decoder.userInfo[codableContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Owner", in: managedObjectContext) else {
                fatalError("failed")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = Int64((try values.decodeIfPresent(Int.self, forKey: .id))!)
        nodeID = try values.decodeIfPresent(String.self, forKey: .nodeID)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        blog = try values.decodeIfPresent(String.self, forKey: .blog)
    }
    
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(nodeID, forKey: .nodeID)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(blog, forKey: .blog)
    }
    
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

