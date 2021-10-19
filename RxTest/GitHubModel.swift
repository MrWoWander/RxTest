//
//  GitHubModel.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 19.10.2021.
//

import Foundation


struct GitHubModel: Codable {
    var totalCount: Int
    var items: [GitHubItemModel]
}

struct GitHubItemModel: Codable {
    var name: String
    var owner: GitHubOwnerModel
    
    init(name: String) {
        self.name = name
        self.owner = GitHubOwnerModel(login: "None")
    }
}

struct GitHubOwnerModel: Codable {
    var login: String
}
