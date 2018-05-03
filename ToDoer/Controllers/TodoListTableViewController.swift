//
//  TodoListTableViewController.swift
//  ToDoer
//
//  Created by Lebediev, Danylo on 23/04/2018.
//  Copyright © 2018 Lebediev, Danylo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: SwipeTableViewController {
    var realm: Realm?
    var todoItems: Results<TodoItem>?
    var selectedCategory: Category? {
        didSet {
            loadTodoItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        tableView.rowHeight = 80.0
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let todoItem = todoItems?[indexPath.row] {
            cell.textLabel?.text = todoItem.title
            cell.accessoryType = todoItem.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Nothing to do in this category"
        }
        
        
        return cell
    }
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm!.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error occuried while updating ToDo item status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK -- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once usr clicks an Add Item button
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm!.write {
                        let newItem = TodoItem()
                        newItem.title = textField.text!
                        currentCategory.todoItems.append(newItem)
                    }
                } catch {
                    print("Error occuried while saving an ToDoItem: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model Manupulation Methods
    private func loadTodoItems() {
        todoItems = selectedCategory?.todoItems.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            do {
                try realm?.write {
                    realm?.delete(itemForDeletion)
                }
            } catch {
                print("Error occuried while deleting ToDo Item \(error)")
            }
        }
    }
    
}

//MARK - Search Bar methods
extension TodoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
                              .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodoItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


