//
//  RepInfoModel.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 20.10.2021.
//

import Foundation


struct RepContent: Codable {
    var name: String
    var path: String
    var type: TypeContent
    
    enum TypeContent: String, Codable {
        case file = "file"
        case directory = "dir"
    }
}
