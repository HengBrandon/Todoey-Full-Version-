//
//  ViewController.swift
//  Todoey
//
//  Created by Heng Brandon on 8/29/18.
//  Copyright © 2018 Heng Brandon. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    let realm = try! Realm()
    var todoItems: Results<Item>?

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = self.todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No item added"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    @objc func tableViewTapped(){
        //messageTextfield.endEditing(true)
    }
    
    //MARK::TableView delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error updating context\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textfiled = UITextField()
        let alert = UIAlertController(title: "Add New Todoey It", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in

                if let currentCatagory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textfiled.text!
                            newItem.dateCreated = Date()
                            currentCatagory.items.append(newItem)
                            self.realm.add(newItem)
                        }
                    }catch{
                       print("Error saving context\(error)")
                    }
                }
                self.tableView.reloadData()
        }
        alert.addTextField { (alterTextFile) in
            alterTextFile.placeholder = "Create new item"
            textfiled = alterTextFile
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func loadItems(){
        todoItems = (selectedCategory?.items.sorted(byKeyPath: "title", ascending: true))
        tableView.reloadData()
    }
}

//MARK: - Search bar method

extension TodoListViewController: UISearchBarDelegate{
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.endEditing(true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
        }else{
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    }
}

