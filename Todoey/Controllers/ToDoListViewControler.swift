//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 04/04/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewControler: UITableViewController {
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    var selecedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "nothing added"
        }
        
        
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    
                }
            }catch{
                print(error)
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey itme", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add Item", style: .default) { (action) in
            
            if let currentCategary = self.selecedCategory{
                do{
                    try self.realm.write {
                    let newitem = Item()
                    newitem.title = textField.text!
                    newitem.dateCreated = Date()
                    currentCategary.items.append(newitem)
                    self.tableView.reloadData()
                }
                }catch{
                    print(error)
                }

        }
            
           
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new Item"
            textField = alertTextField
            
        }
        
        
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK: - Model Minupilation Method
   
    func loadItems(){
        
        todoItems = selecedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

extension ToDoListViewControler : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
