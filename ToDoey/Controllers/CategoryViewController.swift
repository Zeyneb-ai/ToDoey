//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by NebbyKookie on 10/7/20.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()  //codesmell
    
    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        loadData()
     
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let cat = categoryArray?[indexPath.row] {
               
                do{
                    try realm.write {
                        realm.delete(cat)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                }
                }catch {
                    print("error")
                }
                tableView.reloadData()
            }
        }
        

    }

    

    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a Todoey List", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add list", style: .default ) { (action) in
            
            if textField.text!.trimmingCharacters(in: .whitespaces) != "" {
               
                
                let newCategory = Category()
                newCategory.name = textField.text!
              
                // Results is auto-updating! no need for: self.categoryArray.append(newCategory)
                
                self.save(category: newCategory)
                
                
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
        return categoryArray?.count ?? 1 // if not nil return .count, if is nill, return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Todoey Lists Yet"
        
        return cell
        
        
        
    }
    // MARK: - Table view delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    
    
    // MARK: - Data manipulation
    
    func save(category: Category)  {
        
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("encoding error: \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    
    func loadData(){
        
        categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    
}
