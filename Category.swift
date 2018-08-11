//
//  Category.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/9/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    let items = List<Item>()
}

// These structs below are here in case I wanted to download from the API (I currently save locally and then upload to API)

struct CategoryResults: Codable {
    var content: [CategoryCodable]
}

struct CategoryCodable: Codable {
    
    var name: String
    var id: String
}
