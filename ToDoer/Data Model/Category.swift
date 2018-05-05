//
//  Category.swift
//  ToDoer
//
//  Created by Lebediev, Danylo on 30/04/2018.
//  Copyright © 2018 Lebediev, Danylo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let todoItems = List<TodoItem>()
    @objc dynamic var color: String = ""
    
}
