//
//  ViewController.swift
//  Todoey
//
//  Created by YADU MADHAVAN on 15/12/18.
//  Copyright © 2018 emper0r. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared
        .delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

       // let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType  = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
   
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        self.saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add item
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert  = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Do code for what will happen when user presses Add item button in UI Alert
            
         
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print(alertTextField.text!)
            
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    
        //MARK - extra methods
    
    func saveItems(){
        
        do{
            
            try context.save()
            
        }catch{
            
            print("Error saving context,\(error)")
            
        }
        
          tableView.reloadData()
        
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)

        if let additionalPredicate = predicate {

            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalPredicate])
        }else{

            request.predicate = categorypredicate
        }

        do{
            itemArray = try context.fetch(request)
        }catch{
            
        }
    
       
    }
    
  
    
}

extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@ ", searchBar.text!)
        
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       // loadItems(with: request,predicate: predicate)
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            
        }
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
            searchBar.resignFirstResponder()
                
            }
            
            
            
        }else{
            
        }
    }
    
}

