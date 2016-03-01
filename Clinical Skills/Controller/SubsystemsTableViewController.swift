//
//  SubsystemsTableViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/16/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SubsystemsTableViewController: UITableViewController {

	// MARK: - Class Constants
	
	static let storyboardIdentifier = "SubsystemsTableViewController"
	
	// MARK: - Properties
	
	var searchController: UISearchController!
	var fetchedResultsController: NSFetchedResultsController?
	
	var isInitialLoad = true
	var managedParentSystem: SystemManagedObject?
	var defaultSearchPredicate: NSPredicate?
	var searchPhrase: String?
	
	// MARK: - View Controller Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.initializeSearchController()
		self.fetchResults(false, shouldReload: self.isInitialLoad)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.isInitialLoad = false
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = self.fetchedResultsController?.sections {
			return sections.count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = self.fetchedResultsController?.sections {
			return sections[section].numberOfObjects
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(SystemTableViewCell.subsystemCellIdentifier) as! SystemTableViewCell
		let subsystem = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! SystemManagedObject
		cell.systemNameLabel.text = subsystem.name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let subsystem = controller.objectAtIndexPath(indexPath) as? SystemManagedObject {
				if subsystem.subsystems.count == 0 {
					performSegueWithIdentifier(StoryboardSegueIdentifiers.ToDetailsView.rawValue, sender: subsystem)
				} else {
					if let subsystemViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SubsystemTableViewController") as? SubsystemsTableViewController {
						subsystemViewController.title = subsystem.name
						subsystemViewController.managedParentSystem = subsystem
						self.navigationController?.pushViewController(subsystemViewController, animated: true)
					}
				}
			} else {
				print("Error getting Subsystem")
			}
		} else {
			print("Error getting controller")
		}
	}
	
	// MARK: - Fetch Methods
	
	func fetchResults(shouldAskForData: Bool, shouldReload: Bool) {
		if self.fetchedResultsController == nil {
			if self.managedParentSystem != nil {
				self.fetchedResultsController = SubsystemsFetchedResultsControllers.allVisibleSubsystemsFetchedResultsController(self.managedParentSystem!, delegateController: self)
				self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
			}
		}
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error fetching Subsystems")
		}
	}
	
	// MARK: - User Interface Actions
	
	@IBAction func detailsBarButtonPressed(sender: AnyObject) {
		self.performSegueWithIdentifier(StoryboardSegueIdentifiers.ToDetailsView.rawValue, sender: self.managedParentSystem)
	}
	
	// MARK: - Navigation Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let subsystem = sender as? SystemManagedObject {
			if segue.identifier == StoryboardSegueIdentifiers.ToDetailsView.rawValue {
				if let destinationVC = segue.destinationViewController as? SystemDetailViewController {
					destinationVC.navigationItem.title = subsystem.name
					destinationVC.managedSystem = subsystem
				}
			}
		}
	}

}

extension SubsystemsTableViewController: NSFetchedResultsControllerDelegate {
	// No Methods Required Currently
}

// MARK: - Search Delegate Methods

extension SubsystemsTableViewController: UISearchBarDelegate {
	func initializeSearchController() {
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.dimsBackgroundDuringPresentation = true
		self.searchController.definesPresentationContext = true
		self.searchController.searchBar.delegate = self
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height)
		self.searchController.loadViewIfNeeded()
	}
	
	func clearSearch() {
		self.searchPhrase = nil
		self.fetchedResultsController = SubsystemsFetchedResultsControllers.allVisibleSubsystemsFetchedResultsController(self.managedParentSystem!, delegateController: self)
		self.fetchResults(false, shouldReload: true)
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {
			if self.defaultSearchPredicate != nil {
				self.searchPhrase = searchText
				var predicates = [self.defaultSearchPredicate!]
				let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", SystemManagedObject.propertyKeys.name, searchText)
				predicates.append(filterPredicate)
				let fullPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
				self.fetchedResultsController!.fetchRequest.predicate = fullPredicate
				self.fetchResults(false, shouldReload: true)
			}
		} else {
			self.clearSearch()
		}
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		self.clearSearch()
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		searchBar.text = self.searchPhrase
	}
}
