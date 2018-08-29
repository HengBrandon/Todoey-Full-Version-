//
//  ViewController.swift
//  Todoey
//
//  Created by Heng Brandon on 8/29/18.
//  Copyright © 2018 Heng Brandon. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Buy Eggos"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Destroy Demogorgon"
        itemArray.append(newItem2)
    
        
        if let item = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = item
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = self.itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK::TableView delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textfiled = UITextField()
        let alert = UIAlertController(title: "Add New Todoey It", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            //what happen when user click add item button
            let newItem = Item()
            newItem.title = textfiled.text!
            
            self.itemArray.append(newItem)

            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
             self.tableView.reloadData()
        }
        alert.addTextField { (alterTextFile) in
            alterTextFile.placeholder = "Create new item"
            textfiled = alterTextFile
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
}

