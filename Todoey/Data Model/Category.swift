//
//  Category.swift
//  Todoey
//
//  Created by YADU MADHAVAN on 24/12/18.
//  Copyright © 2018 emper0r. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
    
}
