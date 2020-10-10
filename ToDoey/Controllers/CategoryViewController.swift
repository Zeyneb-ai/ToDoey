//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by NebbyKookie on 10/7/20.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArray = [Category]()
    
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadData()
     
    }

    

    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a Todoey List", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add list", style: .default ) { (action) in
            
            if textField.text!.trimmingCharacters(in: .whitespaces) != "" {
               
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
              
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
                
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new list"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
    }
    
    
        
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
        
        
    }
    // MARK: - Table view delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    
    
    // MARK: - Data manipulation
    
    func saveCategories()  {
        
        do {
            try context.save()
        } catch {
            print("encoding error: \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        
    
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    
}
