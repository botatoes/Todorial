//
//  CategoryViewController.swift
//  Todorial
//
//  Created by Bo-ying Fu on 12/18/18.
//  Copyright © 2018 Botatoes. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initial load from core data
        loadCategory()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
    
        cell.textLabel?.text = category.name
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
        
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
    
            self.saveCategory()
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
    
    func saveCategory() {
    
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    //item.fetchRequest is default value if with is not present
    func loadCategory (with request : NSFetchRequest<Category> = Category.fetchRequest()) {
    
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
    
        tableView.reloadData()
    
    }
    
    //MARK: - TableView Datasource Methods
    
    //MARK: - TableView Delegate Methods

    //MARK: - Data Manipulation Methods

}

