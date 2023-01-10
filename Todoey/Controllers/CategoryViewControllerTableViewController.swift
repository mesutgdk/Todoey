//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//

import UIKit

import RealmSwift

class CategoryViewControllerTableViewController: UITableViewController {
    let realm = try! Realm()

    var categories : Results<Category>?
    
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
        
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    // MARK: -Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController (title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategories(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create a New Category"
        }
        present(alert, animated: true, completion: nil)
     
    }
    func saveCategories (category: Category) {
        do{
            try realm.write{
                realm.add(category)
            }
        }catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories () {
        categories = realm.objects( Category.self)
        tableView.reloadData()
    }
}
extension CategoryViewControllerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
     
}
