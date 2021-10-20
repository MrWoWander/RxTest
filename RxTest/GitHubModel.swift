//
//  GitHubModel.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 19.10.2021.
//

import Foundation


protocol RepoInfo {
    var nameRepo: String { get }
    var authorRepo: String { get }
}

struct GitHubModel: Codable {
    var totalCount: Int
    var items: [GitHubItemModel]
}

struct GitHubItemModel: Codable, RepoInfo {
    var name: String
    var owner: GitHubOwnerModel
    
    init(name: String) {
        self.name = name
        self.owner = GitHubOwnerModel(login: "None")
    }
    
    var nameRepo: String {
        get {
            return name
        }
    }
    
    var authorRepo: String {
        get {
            return owner.login
        }
    }
}

struct GitHubOwnerModel: Codable {
    var login: String
}
