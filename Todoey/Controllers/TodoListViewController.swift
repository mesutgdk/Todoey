//
//  ViewController.swift
//  Todoey

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    // if u want to delete, use first line
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error deleting done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Item IBAction Button Pressed Part
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Button on UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.dateCreated = Date()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Error saving new items,\(error)")
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            }catch {
                print("Error deleting item,\(error)")
            }
        }
    }
}


extension TodoListViewController: UISearchBarDelegate {
   
    
    //MARK: - Search Item Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            //.sorted(byKeyPath: "dateCreated", ascending: false)
            //.sorted(byKeyPath: "title", ascending: true)
            
        tableView.reloadData()
    }
    
    //MARK: - Search Button Back Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
      
    }
    
    //MARK: - Model Manupilation Methods
    func saveItem (item: Item) {
        do{
            try realm.write{
                realm.add(item)
            }
        }catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
 
    func loadItem () {
        todoItems = selectedCategory?.items.sorted(byKeyPath:"title", ascending: true)
        tableView.reloadData()
    }
   
   
}
