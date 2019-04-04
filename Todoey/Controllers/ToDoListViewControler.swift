//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 04/04/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import UIKit

class ToDoListViewControler: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
   
    
    override func viewDidLoad() {
        
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find mike"
      itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "batmn"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "awesome"
        itemArray.append(newItem3)

        loadItems()
        
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("cell for row at inexpath")
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        tableView.reloadData()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey itme", message: "", preferredStyle: .alert)
      
        let action = UIAlertAction(title: "add Item", style: .default) { (action) in
           let newitem = Item()
            newitem.title = textField.text!
            
            self.itemArray.append(newitem)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new Item"
            textField = alertTextField
            
        }
        
        
        
        present(alert,animated: true,completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }catch{
            print("Error in \(error.localizedDescription)")
        }
        
    }
    func loadItems(){
        let data = try? Data(contentsOf: dataFilePath!)
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([Item].self, from: data!)
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

