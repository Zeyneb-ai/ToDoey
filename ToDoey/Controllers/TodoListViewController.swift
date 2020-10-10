//
//  ViewController.swift
//  ToDoey
//
//  Created by NebbyKookie on 10/6/20.
//

import UIKit
import CoreData

class TodoListViewController : UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        
    }
    

    //MARK - Tableview datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row]
       
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //delete
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Item to List
    
    @IBAction func addtoList(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when add item is clicked
            if textField.text!.trimmingCharacters(in: .whitespaces) != "" {
               
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                
                newItem.parentCategory = self.selectedCategory
                    
                self.itemArray.append(newItem)
                
                self.saveItems()
                
                
            }
    }
    
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
    }
    
    
 
    
    func saveItems()  {
        
        
        
        do {
            try context.save()
        } catch {
            print("encoding error: \(error)")
        }
        self.tableView.reloadData()
        
        
    }
    
                                                     //default without given
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil) {
        let predicate2 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, predicate2])
        } else {
            request.predicate = predicate2
        }
        
        
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print(error)
        }
        self.tableView.reloadData()
        
    }
    
  
    
    
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.trimmingCharacters(in: .whitespaces) != "" {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! )
            //title that CONTAINS arguments
            let sorter = NSSortDescriptor(key: "title", ascending: true)
            
      
            request.sortDescriptors = [sorter]
            
            loadItems(with: request, predicate: predicate)
            
            
            tableView.reloadData()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //no longer the current selected thing in background
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}

    
    
    
    
    


