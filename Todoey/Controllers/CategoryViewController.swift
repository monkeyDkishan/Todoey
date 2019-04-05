//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 05/04/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCatogries()
       
      

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

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! ToDoListViewControler
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selecedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Data Minupilation

    
    func saveCategories(){
        do{
        try context.save()
        }catch{
            print("error saving catagories", error)
        }
        
        tableView.reloadData()
        
    }
    
    func loadCatogries(){
    
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
       categories = try context.fetch(request)
        }catch{
            print("error loading catagories",error)
        }
        tableView.reloadData()
    }

 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        
        let alert = UIAlertController(title: "ADD new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
     
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "add new Category"
        }
        
        present(alert,animated: true,completion: nil)
    }
    
    

    
}
