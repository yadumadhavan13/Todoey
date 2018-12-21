//
//  ViewController.swift
//  Todoey
//
//  Created by YADU MADHAVAN on 15/12/18.
//  Copyright © 2018 emper0r. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    
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
            
            let newItem = Item()
            newItem.title = textfield.text!
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
        
        let encoder = PropertyListEncoder()
        
        do{
            
            let data = try encoder.encode(self.itemArray)
            
            try data.write(to: self.datafilePath!)
            
        }catch{
            
            print("Error encoding item array ,\(error)")
            
        }
        
          tableView.reloadData()
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: datafilePath!){
            let decoder   = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self,from : data)
            }catch{
                print("Error decoding item array , \(error)")
            }
        }
    }
    
}

