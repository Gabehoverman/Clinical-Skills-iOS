//
//  SubsystemsTableViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/16/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SubsystemsTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {

	// MARK: - Properties
	
	var searchController: UISearchController!
	var fetchedResultsController: NSFetchedResultsController?
	
	var isInitialLoad = true
	var parentSystem: System?
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
	
	// MARK: - IB Actions
	
	@IBAction func detailsBarButtonPressed(sender: AnyObject) {
		self.performSegueWithIdentifier(StoryboardSegueIdentifiers.ToDetailsView.rawValue, sender: self.parentSystem)
	}
	
	// MARK: - Data Methods
	
	func fetchResults(shouldAskForData: Bool, shouldReload: Bool) {
		if self.fetchedResultsController == nil {
			if self.parentSystem != nil {
				self.fetchedResultsController = SubsystemsFetchedResultsControllers.allVisibleSubsystemsFetchedResultsController(self.parentSystem!, delegateController: self)
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
	
	// MARK: - Search Methods
	
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
		self.fetchedResultsController = SubsystemsFetchedResultsControllers.allVisibleSubsystemsFetchedResultsController(self.parentSystem!, delegateController: self)
		self.fetchResults(false, shouldReload: true)
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {
			if self.defaultSearchPredicate != nil {
				self.searchPhrase = searchText
				var predicates = [self.defaultSearchPredicate!]
				let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue, searchText)
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
		let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.Subsystem.rawValue) as! SystemTableViewCell
		let subsystem = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! System
		cell.systemNameLabel.text = subsystem.systemName
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let subsystem = controller.objectAtIndexPath(indexPath) as? System {
				if subsystem.subsystems == nil || subsystem.subsystems?.count == 0 {
					performSegueWithIdentifier(StoryboardSegueIdentifiers.ToDetailsView.rawValue, sender: subsystem)
				} else {
					if let subsystemViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SubsystemTableViewController") as? SubsystemsTableViewController {
						subsystemViewController.parentSystem = subsystem
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
	
	// MARK: - Navigation Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let subsystem = sender as? System {
			if segue.identifier == StoryboardSegueIdentifiers.ToDetailsView.rawValue {
				if let destinationVC = segue.destinationViewController as? SystemDetailViewController {
					destinationVC.navigationItem.title = subsystem.systemName
					destinationVC.system = subsystem
				}
			}
		}
	}

}
