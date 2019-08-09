//
//  ItemTableViewController.swift
//  ShopList
//
//  Created by Mitch Merrell on 8/9/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ItemController.sharedInstance.fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.update(withItem: item)
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ItemController.sharedInstance.deleteItem(item: item)
        }
    }
    
    //MARK: Actions
    
    @IBAction func addItemButtonTapped(_ sender: Any) {
        newItem()
    }
    
    func newItem() {
        let alert = UIAlertController(title: "New Item", message: "Add a new item to your shopping list", preferredStyle: .alert)
        alert.addTextField {(textField) in }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(action) in
            guard let newItem = alert.textFields?[0].text else { return }
            ItemController.sharedInstance.createItem(name: newItem)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ItemTableViewController: ButtonTableViewCellDelegate {
    func buttonTapped(_ sender: ButtonTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else { return }
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: index)
        
        ItemController.sharedInstance.toggleIsComplete(item: item)
        sender.update(withItem: item)
    }
}

extension ItemTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .right)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: return
        }
    }
}
