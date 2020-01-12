//
//  Repository.swift
//  GitHubRepository
//
//  Created by Eman Alsabbagh on 4/11/19.
//  Copyright © 2019 Eman Alsabbagh. All rights reserved.
//

import Foundation
import CoreData

final class Repository: NSManagedObject, Codable  {
    
    @NSManaged var id: Int64
    @NSManaged var nodeID: String?
    @NSManaged var name, fullName: String?
    @NSManaged var htmlURL: String?
    @NSManaged var descriptionField: String?
    @NSManaged var forksCount: Int64
    @NSManaged var createdAt: String?
    @NSManaged var language: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case htmlURL = "html_url"
        case descriptionField = "description"
        case forksCount = "forks_count"
        case createdAt = "created_at"
        case language
        
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        
        
        guard let codableContext = CodingUserInfoKey.init(rawValue: "context"),
            let managedObjectContext = decoder.userInfo[codableContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Repository", in: managedObjectContext) else {
                fatalError("failed")
        }
        
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int64.self, forKey: .id) ?? 0
        nodeID = try values.decodeIfPresent(String.self, forKey: .nodeID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        htmlURL = try values.decodeIfPresent(String.self, forKey: .htmlURL)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        forksCount = try values.decodeIfPresent(Int64.self, forKey: .forksCount) ?? 0
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        language = try values.decodeIfPresent(String.self, forKey: .language)
    }
    
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(nodeID, forKey: .nodeID)
        try container.encode(name, forKey: .name)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(htmlURL, forKey: .htmlURL)
        try container.encode(descriptionField, forKey: .descriptionField)
        try container.encode(forksCount, forKey: .forksCount)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(language, forKey: .language)
        
    }
}



