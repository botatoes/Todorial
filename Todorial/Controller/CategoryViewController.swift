//
//  CategoryViewController.swift
//  Todorial
//
//  Created by Bo-ying Fu on 12/18/18.
//  Copyright © 2018 Botatoes. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initial load from core data
        loadCategory()
        
        tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.backgroundColor = UIColor(hexString: (category.color) )
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? FlatBlack(), returnFlat: true)
            cell.textLabel?.text = category.name
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SwipeTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        var textField = UITextField()
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
            
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
                //when user clicks add items
        
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
    
            self.saveCategory(category: newCategory)
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
    
    func saveCategory(category : Category) {
        do { try realm.write { realm.add(category) }
        } catch { print("Error saving context \(error)") }
    }
    
    //item.fetchRequest is default value if with is not present
    func loadCategory () {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryDeletion = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categoryDeletion)
                }
            } catch {
                print("Error deleting cell \(error)")
            }
        }
    }
}

