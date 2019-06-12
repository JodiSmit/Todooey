//
//  ViewController.swift
//  Todooey
//
//  Created by Jodi Smit on 6/10/19.
//  Copyright © 2019 Spicy Purrito. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		loadItems()
		
	}

	//MARK - TableView DataSource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
		
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		
		cell.accessoryType = item.done ? .checkmark : .none
		
		return cell
	}
	
	//MARK - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		saveItems()
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	//MARK - Add new items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todooey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			let newItem = Item()
			newItem.title = textField.text!
			self.itemArray.append(newItem)
			
			self.saveItems()

		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create New Item"
			textField = alertTextField
		}
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	func saveItems() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding itemArray \(error)")
		}
		
		tableView.reloadData()
	}
	
	func loadItems() {

			if let data = try? Data(contentsOf: dataFilePath!) {
				let decoder = PropertyListDecoder()
				do {
					try itemArray = decoder.decode([Item].self, from: data)
				} catch {
					print("Error decoding itemArray \(error)")
				}
				
			}

	}
}

