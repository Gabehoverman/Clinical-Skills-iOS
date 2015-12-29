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
class SystemsTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
	
	// MARK: - Properties
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	var fetchedResultsController: NSFetchedResultsController?
	
	var isInitialLoad = true
//	var dataHelper: DataHelper?
	
	var defaultSearchPredicate: NSPredicate?
	var searchPhrase: String?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.searchController = UISearchController(searchResultsController: nil)
//		if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//			self.dataHelper = DataHelper(context: context, delegate: self)
//		}
		self.refreshControl?.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: .ValueChanged)
		self.initializeSearchController()
		self.initializeActivityIndicator()
		self.fetchResults(self.isInitialLoad, shouldReload: false)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.isInitialLoad = false
	}

	// MARK: - Data Methods
	
	func fetchResults(shouldAskForData: Bool, shouldReload: Bool) {
		if self.fetchedResultsController == nil {
			self.fetchedResultsController = SystemFetchedResultsControllers.allVisibleSystemsResultController(self)
			self.defaultSearchPredicate = self.fetchedResultsController?.fetchRequest.predicate
		}
		do {
			if shouldAskForData {
//				if self.dataHelper != nil {
//					self.dataHelper!.seed()
//				}
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
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.fetchResults(true, shouldReload: true)
	}
	
	// MARK: - Data Helper Delegate Methods
	
	func didBeginDataRequest() {
		if self.refreshControl != nil {
			if !self.refreshControl!.refreshing {
				self.performSelectorOnMainThread("showActivityIndicator", withObject: nil, waitUntilDone: false)
			}
		}
	}
	
	func didReceiveData() {
		self.foundNewData()
	}
	
	func didFinishDataRequest() {
		if self.refreshControl != nil {
			if self.refreshControl!.refreshing {
				self.refreshControl!.endRefreshing()
			} else {
				self.performSelectorOnMainThread("hideActivityIndicator", withObject: nil, waitUntilDone: false)
			}
		}
	}
	
	// MARK: - Search Methods
	
	func initializeSearchController() {
		self.searchController.dimsBackgroundDuringPresentation = true
		self.searchController.definesPresentationContext = true
		self.searchController.searchBar.delegate = self
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height)
		self.searchController.loadViewIfNeeded()
	}
	
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
	
	// MARK: - Activity Indicator Methods
	
	func initializeActivityIndicator() {
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		self.activityIndicator!.center = self.tableView.center
		self.activityIndicator!.hidesWhenStopped = true
		self.view.addSubview(self.activityIndicator!)
		self.activityIndicator!.bringSubviewToFront(self.view)
	}
	
	func showActivityIndicator() {
		self.activityIndicator!.startAnimating()
	}
	
	func hideActivityIndicator() {
		self.activityIndicator!.stopAnimating()
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
