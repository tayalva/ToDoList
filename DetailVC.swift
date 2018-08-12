//
//  DetailVC.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/9/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class DetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addItemTextField: UITextField!
    
    let realm = try! Realm()
    var items: Results<Item>?
    let networkManager = NetworkManager()
    
    
 // Selects correct category
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addItemTextField.delegate = self
        
  // reorders items that are completed to be at the bottom
        items = items?.sorted(byKeyPath: "done", ascending: true)
    }

    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
    }
    
    @IBAction func addItemButton(_ sender: Any) {
        
        if let currentCategory = self.selectedCategory {
            
            
                    let newItem = Item()
                    newItem.name = addItemTextField.text!
                    newItem.categoryId = selectedCategory?.id ?? "1"
            addItemTextField.endEditing(true)
        
                    
        //Adds item to API and also returns an ID to be saved by REALM
            
                    let json: Parameters = ["name": newItem.name, "description": "", "category_id": newItem.categoryId, "due":""]
                    networkManager.post(params: json, endpoint: EndPoints.addItem) { (fetchedInfo, error) in
                        
                        if let itemID = fetchedInfo {
                            
                            OperationQueue.main.addOperation {
                                
                                do {
                                    try self.realm.write {
                                        newItem.id = itemID
                                        currentCategory.items.append(newItem)
                                        self.tableView.reloadData()
                                    }
                                } catch {
                                    
                                }
                                
                            }
                            
                        }
                  
                    }
                    
                    
                
            
     
        }
        
    
    
    }
    
    
    

}


// Table View Helper Methods

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            
            do {
            try realm.write {
            
                item.done = !item.done
            }
            }catch {
                print("error saving done status")
            }
            
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
  ///// SWIPE DELETE
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
           
            if let item = self.items?[indexPath.row] {
              // Deletes from API
                let params = ["id": item.id]
                self.networkManager.delete(params: params, endpoint: EndPoints.deleteItem)
                
                
                do {
                    
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print("couldn't delete item")
                }
                
            }
        
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
      ///// SWIPE EDIT
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            
            var textField = UITextField()
            if let item = self.items?[indexPath.row]{
                
                let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Update", style: .default) { (action) in
            // Edits to API
                    let params = ["id": item.id, "name": textField.text!, "description":"", "due": "", "completed": "\(item.done)"]
                    self.networkManager.update(params: params, endpoint: EndPoints.updateItem)
                    
                    do {
                        try self.realm.write {
                            item.name = textField.text!
                            self.tableView.reloadData()
                            
                        }
                    } catch {
                        print("update failed")
                    }
                    
                }
                
                alert.addAction(action)
                alert.addTextField { (field) in
                    
                    field.text = item.name
                    textField = field

                }
                
            
                self.present(alert, animated: true, completion: nil)
                
                
            }

            
        }
        edit.backgroundColor = UIColor.orange
        return [delete, edit]
        
    }
    
}


extension DetailVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

