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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath!)
        
        loadItems()
    
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
        
        saveItems()
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
            
            self.saveItems()
            
        }
        alert.addTextField { (alterTextFile) in
            alterTextFile.placeholder = "Create new item"
            textfiled = alterTextFile
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    //    func loadItems(){
    //        if let data = try? Data(contentsOf: dataFilePath!){
    //            let decoder = PropertyListDecoder()
    //            do {
    //                itemArray = try decoder.decode([Item].self, from: data)
    //            }catch{
    //                print("Error decoding item array, \(error)")
    //            }
    //        }
    //    }
}

