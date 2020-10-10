//
//  Category.swift
//  ToDoey
//
//  Created by NebbyKookie on 10/10/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    
    let items = List<Item>()
    
    
}
