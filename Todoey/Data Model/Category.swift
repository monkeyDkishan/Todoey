//
//  Category.swift
//  Todoey
//
//  Created by Mac on 05/04/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>() // Forward relationship
    
}
