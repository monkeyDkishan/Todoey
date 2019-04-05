//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 05/04/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCatogries()
       
      

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Catagories added yet"
        
        return cell
        
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! ToDoListViewControler
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selecedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Minupilation

    
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving catagories", error)
        }
        
        tableView.reloadData()
        
    }
    
    func loadCatogries(){

         categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        
        let alert = UIAlertController(title: "ADD new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
     
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "add new Category"
        }
        
        present(alert,animated: true,completion: nil)
    }
    
    

    
}
