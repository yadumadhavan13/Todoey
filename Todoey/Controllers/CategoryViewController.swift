//
//  CategoryViewController.swift
//  Todoey
//
//  Created by YADU MADHAVAN on 23/12/18.
//  Copyright © 2018 emper0r. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var category = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    //MARK : - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory(){
        
        do{
              try context.save()
        }catch{
            print("Error saving context,\(error)")
        }
        
        tableView.reloadData()
        
      
        
    }
    
    func loadCategory(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
               category =  try context.fetch(request)
        }catch{
            
            print("Error loading category\(error)")
        }
        
        tableView.reloadData()
     
        
    }
    
    
    //MARK : - Add new Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield  = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            
            self.category.append(newCategory)
            
            self.saveCategory()
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add new category"
            
        }
        
        present(alert,animated: true,completion: nil)
    }
    
}
