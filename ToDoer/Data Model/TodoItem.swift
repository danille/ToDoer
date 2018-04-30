//
//  TodoItem.swift
//  ToDoer
//
//  Created by Lebediev, Danylo on 30/04/2018.
//  Copyright © 2018 Lebediev, Danylo. All rights reserved.
//

import Foundation
import RealmSwift


class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
