//
//  Item.swift
//  Todoey
//
//  Created by YADU MADHAVAN on 24/12/18.
//  Copyright © 2018 emper0r. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
