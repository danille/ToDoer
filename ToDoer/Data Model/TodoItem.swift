//
//  TodoItem.swift
//  ToDoer
//
//  Created by Lebediev, Danylo on 25/04/2018.
//  Copyright © 2018 Lebediev, Danylo. All rights reserved.
//

import Foundation

class TodoItem {
    var title: String = ""
    var isDone: Bool = false
    
    init(todoItemTitle: String, isDone: Bool) {
        self.title = todoItemTitle
        self.isDone = isDone
    }
}
