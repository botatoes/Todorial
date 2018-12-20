//
//  ViewController.swift
//  Todorial
//
//  Created by Bo-ying Fu on 12/15/18.
//  Copyright © 2018 Botatoes. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController{

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    override var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initial load from core data
        tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        //delete the items
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        //saveItems()
        
        if let checkMark = todoItems?[indexPath.row] {
            try! realm.write {
                checkMark.done = !checkMark.done
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //when user clicks add items
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
            }
            
            self.tableView.reloadData()

        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //when user clicks add items
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    
//item.fetchRequest is default value if with is not present
    func loadItems () {
        
      todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoDelete = self.todoItems?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(todoDelete)
                }
            } catch {
                print("Error deleting cell \(error)")
            }
        }
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            //default fetches all the items in the database
            loadItems()
            //gets rid of the keyboard when you get out of search
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}

