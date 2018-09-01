//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Heng Brandon on 8/30/18.
//  Copyright © 2018 Heng Brandon. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var catagories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatagories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catagories?[indexPath.row].name ?? "No Categorized Added"
        return cell
    }
    
    //MARK: - add new categories
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catagory", style: .default) { (alertAction) in
            let newCatagory = Category()
            newCatagory.name = textfield.text!
            
            self.saveCatagories(categories: newCatagory)
        }
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add your new Catagory Here"
            textfield = alertTextfield
        }
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: -Data Manipulation Method
    func saveCatagories(categories: Category){
        do{
            try realm.write {
                realm.add(categories)
            }
        }catch{
            print("Error saving context\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCatagories() {
        catagories = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    
    //MARK: -tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = catagories?[indexPath.row]
        }
    }
}
