//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
        
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController (title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        saveData()
    }
    func saveData () {
        do{
            try context.save()
        }catch {
            print("Error saving context, \(error)")
        }
    }
    func loadData () {
        let request: NSFetchRequest <Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}
extension CategoryViewControllerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories[indexPath.row].name ?? "none")
    }
}

