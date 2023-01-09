//
//  ViewController.swift
//  Todoey

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            //loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //main.stroybard'tan search barı ekranın üstündeki ilk tuşa +ctrl ile sürüklediğimiz için kod ile yazılmadı
        //ayrıca UISearchBarDelegate extension içinde olduğu için viewDidLoad'a tanımlanmıyor! Bunun yerine main.storyboard yolunu tercih ettik
        //searchBar.delegate = self
       // loadData()
      
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .nones
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Item IBAction Button Pressed Part
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks the Add Button on UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
extension TodoListViewController: UISearchBarDelegate {
   
    
    //MARK: - Search Item Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadItem(with:request, predicate: predicate)
    }
    
    //MARK: - Search Button Back Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
    
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItem()
        }
      
    }
    
    //MARK: - Model Manupilation Methods
    func saveItem () {
        do {
           try context.save()
        }catch {
            print("Error encoding itemarray, \(error)")
        }
        tableView.reloadData()
    }
 
    func loadItem () {
        todoItems = selectedCategory?.items.sorted(byKeyPath:"title", ascending: true)
        tableView.reloadData()
    }
   
}
