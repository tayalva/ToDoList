//
//  Item.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/9/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var categoryId: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
