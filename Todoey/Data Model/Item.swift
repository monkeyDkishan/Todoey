//
//  Item.swift
//  Todoey
//
//  Created by Mac on 05/04/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
     @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // reverse Relationship
}
