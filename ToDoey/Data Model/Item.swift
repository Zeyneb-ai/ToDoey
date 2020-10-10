//
//  Item.swift
//  ToDoey
//
//  Created by NebbyKookie on 10/10/20.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated : Date  = Date()
    var parentCategory = LinkingObjects(fromType: Category.self , property: "items" )
}
