//
//  TodoListTableViewController.swift
//  ToDoer
//
//  Created by Lebediev, Danylo on 23/04/2018.
//  Copyright © 2018 Lebediev, Danylo. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist"))
        
        loadTodoItems()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let todoItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = todoItem.title
        cell.accessoryType = todoItem.isDone ? .checkmark : .none
    
        return cell
    }
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone

        saveTodoItems()

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    //MARK -- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            //what will happen once usr clicks an Add Item button
            
            
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text
            newItem.isDone = false
            
            self.itemArray.append(newItem)
            
            self.saveTodoItems()
            
            self.tableView.reloadData()
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model Manupulation Methods
    private func saveTodoItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadTodoItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()) {
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error occuried while loading data \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK - Search Bar methods
extension TodoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
    
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTodoItems(with: request)
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

