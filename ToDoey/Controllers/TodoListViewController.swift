//
//  ViewController.swift
//  ToDoey
//
//  Created by NebbyKookie on 10/6/20.
//

import UIKit
import RealmSwift

class TodoListViewController : UITableViewController {
    
    let realm = try! Realm()
    
    var itemRes: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
            self.title = selectedCategory?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        
    }
    

    //MARK - Tableview datasource Methods
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            if let item = itemRes?[indexPath.row] {
               
                do{
                    try realm.write {
                        realm.delete(item)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                } catch {
                    print("error")
                }
                
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemRes?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemRes?[indexPath.row]{
            
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            
            
        } else   {
            cell.textLabel?.text = "No Todo Items Added"
        }
        
        
        return cell
    }
    
    
    //MARK - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       //itemRes[indexPath.row].done = itemRes[indexPath.row].done
        
        //delete
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        if let item = itemRes?[indexPath.row] {
            do{
                try realm.write {
                item.done =  !item.done
            }
            } catch {
                print("error")
            }
        

       
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        }
    }
    
    //MARK - Add New Item to List
    
    @IBAction func addtoList(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when add item is clicked
            if textField.text!.trimmingCharacters(in: .whitespaces) != "" {
               
                if let currentCategory = self.selectedCategory{
                    
                        

                    
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                            //newItem.parentCategory = self.selectedCategory
                            
                        }
                    } catch {
                        print("encoding error: \(error)")
                    }
                    self.tableView.reloadData()
                    
                }
                
                
            }
    }
    
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
    }
    
    
 
    

    
                                                     //default without given
    func loadItems() {
//        let predicate2 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, predicate2])
//        } else {
//            request.predicate = predicate2
//        }
        
        
        do {
            itemRes = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
        } catch {
            print(error)
        }
        self.tableView.reloadData()
        
    }
    
  
    
    
    
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! )
//            //title that CONTAINS arguments
//            let sorter = NSSortDescriptor(key: "title", ascending: true)
//
//
//            request.sortDescriptors = [sorter]
//
//            loadItems(with: request, predicate: predicate)
            
        if searchBar.text!.trimmingCharacters(in: .whitespaces) != "" {
            itemRes = itemRes?.filter("title CONTAINS[cd] %@",  searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.trimmingCharacters(in: .whitespaces) != "" {
            itemRes = itemRes?.filter("title CONTAINS[cd] %@",  searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
        
        if searchBar.text?.count == 0 {
            loadItems()

            //no longer the current selected thing in background
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }
}


    
    
    
    
    


