//
//  ViewController.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/8/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newCategoryView: UIView!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var addCategoryTextField: UITextField!
    
  
    
    
    var itemList = ["Grocery List", "Work", "Vacation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
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
            
            itemList.append(addCategoryTextField.text!)
            tableView.reloadData()
        }
        addCategoryTextField.text = ""
        
    }
    


}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 25)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
        let item = self.itemList[indexPath.row]
        self.itemList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    return [delete]
    }
    
}

