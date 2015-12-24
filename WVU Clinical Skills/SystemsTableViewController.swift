//
//  SystemsTableViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
	Table View displaying all System data inside the database
*/
class SystemsTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate, DataHelperDelegate {
	
	// MARK: - Properties
	let searchController = UISearchController(searchResultsController: nil)
	var fetchedResultsController: NSFetchedResultsController?
	
	var isInitialLoad = true
	var dataHelper: DataHelper?
	
	var defaultSearchPredicate: NSPredicate?
	var searchPhrase: String?
	
	// MARK: - View Controller Methods
	
	override func viewWillDisappear(animated: Bool) {
		self.isInitialLoad = false
	}
	
	override func viewDidLoad() {
		if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
			self.dataHelper = DataHelper(context: context, delegate: self)
		}
		self.refreshControl?.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: .ValueChanged)
		self.searchController.dimsBackgroundDuringPresentation = true
		self.searchController.definesPresentationContext = true
		self.searchController.searchBar.delegate = self
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.fetchResults(self.isInitialLoad, shouldReload: false)
	}
	
	// MARK: - Data Methods
	
	func fetchResults(shouldAskForData: Bool, shouldReload: Bool) {
		if self.fetchedResultsController == nil {
			self.fetchedResultsController = SystemFetchedResultsControllers.allVisibleSystemsResultController(self)
			self.defaultSearchPredicate = self.fetchedResultsController?.fetchRequest.predicate
		}
		do {
			if shouldAskForData {
				if self.dataHelper != nil {
					self.dataHelper!.seed()
				}
			}
			try self.fetchedResultsController!.performFetch()
			
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error occurred during System fetch")
		}
	}
	
	func foundNewData() {
		self.fetchResults(false, shouldReload: false)
		self.tableView.performSelectorOnMainThread(Selector("reloadData"), withObject: nil, waitUntilDone: false)
	}
	
	func didReceiveData() {
		self.foundNewData()
	}
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.fetchResults(true, shouldReload: true)
		self.refreshControl?.endRefreshing()
	}
	
	// MARK: - Search Methods
	
	func clearSearch() {
		self.searchPhrase = nil
		self.fetchedResultsController = SystemFetchedResultsControllers.allVisibleSystemsResultController(self)
		self.fetchResults(false, shouldReload: true)
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {
			if self.defaultSearchPredicate != nil {
				self.searchPhrase = searchText
				var predicates = [self.defaultSearchPredicate!]
				let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", "systemName", searchText)
				predicates.append(filterPredicate)
				let fullPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
				self.fetchedResultsController?.fetchRequest.predicate = fullPredicate
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
	
	// MARK: - Table View Methods
	
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
		let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.systemCell) as! SystemTableViewCell
		let system = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! System
		cell.systemNameLabel.text = system.systemName
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let system = controller.objectAtIndexPath(indexPath) as? System {
				if system.subsystems == nil || system.subsystems?.count == 0 {
					performSegueWithIdentifier(StoryboardSegueIdentifiers.toDetailView, sender: system)
				} else {
					performSegueWithIdentifier(StoryboardSegueIdentifiers.toSubsystemView, sender: system)
				}
			} else {
				print("Error getting System")
			}
		} else {
			print("Error getting controller")
		}
	}
	
	// MARK: - Navigation Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let system = sender as? System {
			if segue.identifier == StoryboardSegueIdentifiers.toDetailView {
				if let destination = segue.destinationViewController as? SystemDetailViewController {
					destination.navigationItem.title = system.systemName
					destination.system = system
				}
			} else if segue.identifier == StoryboardSegueIdentifiers.toSubsystemView {
				if let destination = segue.destinationViewController as? SubsystemsTableViewController {
					destination.navigationItem.title = system.systemName
					destination.parentSystem = system
				}
			}
		}
	}
	
}
