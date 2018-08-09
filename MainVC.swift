//
//  ViewController.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/8/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newCategoryView: UIView!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var addCategoryTextField: UITextField!
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
 
    
    var itemList = ["Grocery List", "Work", "Vacation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    @IBAction func addCategory(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
          self.newCategoryView.alpha = 1.0
        })
    }
    
    @IBAction func doneButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.newCategoryView.alpha = 0.0
        })
        
        if addCategoryTextField.text != "" {
            
            let newCategory = Category()
            newCategory.name = addCategoryTextField.text!
            self.save(category: newCategory)
            print(Realm.Configuration.defaultConfiguration.fileURL)
            
            tableView.reloadData()
        }
        addCategoryTextField.text = ""
        
    }
    
    func save(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("error saving!")
        }

    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    


}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 25)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailViewSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
        
            if let category = self.categories?[indexPath.row]{
                
                do {
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                }catch {
                    print("could not delete category")
                }
                
            }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    return [delete]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
