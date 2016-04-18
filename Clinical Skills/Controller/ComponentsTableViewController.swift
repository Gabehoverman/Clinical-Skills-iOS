//
//  ComponentsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/9/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Async

class ComponentsTableViewController : UITableViewController {
	
	// MARK: - Properties
	
	var system: System?
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	var presentingAlert: Bool = false
	
	var remoteConnectionManager: RemoteConnectionManager?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if self.system != nil {
			
			self.fetchedResultsController = FetchedResultsControllers.componentsFetchedResultsController(self.system!)
			self.fetchResultsWithReload(false)
		
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
			
			self.initializeSearchController()
			self.initializeActivityIndicator()
			
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			self.remoteConnectionManager?.fetchComponents(forSystem: self.system!)
		
			NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
		}
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = self.fetchedResultsController?.fetchedObjects?.count {
			return count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightSemibold)
		if let managedComponent = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? ComponentManagedObject {
			cell.textLabel?.text = managedComponent.name
		} else {
			cell.textLabel?.text = "Error Fetching Component Name"
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if self.fetchedResultsController != nil {
			if let managedComponent = self.fetchedResultsController!.objectAtIndexPath(indexPath) as? ComponentManagedObject {
				if self.tabBarController?.selectedIndex == StoryboardIdentifiers.tab.clinicalSkills {
					self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toComponentDetailsView, sender: managedComponent)
				} else {
					self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toSpecialTestsView, sender: managedComponent)
				}
			}
		}
	}
	
	// MARK: - Fetch Methods
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error Fetching Components")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
				self.presentingAlert = true
				self.presentViewController(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
	
	// MARK: - Core Data Notification Methods
	
	func backgroundManagedObjectContextDidSave(saveNotification: NSNotification) {
		Async.main {
			if let workingContext = self.fetchedResultsController?.managedObjectContext {
				workingContext.mergeChangesFromContextDidSaveNotification(saveNotification)
			}
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchComponents(forSystem: self.system!)
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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryboardIdentifiers.segue.toComponentDetailsView {
			if let destination = segue.destinationViewController as? ComponentDetailsTableViewController {
				if let managedComponent = sender as? ComponentManagedObject {
					destination.component = Component(managedObject: managedComponent)
				}
			}
		} else if segue.identifier == StoryboardIdentifiers.segue.toSpecialTestsView {
			if let destination = segue.destinationViewController as? SpecialTestsTableViewController {
				if let managedComponent = sender as? ComponentManagedObject {
					destination.component = Component(managedObject: managedComponent)
				}
			}
		}
	}
	
}

// MARK: - Remote Connection Manager Delegate Methods

extension ComponentsTableViewController : RemoteConnectionManagerDelegate {
	
	func didBeginDataRequest() {
		if self.refreshControl != nil {
			if !self.refreshControl!.refreshing {
				Async.main {
					self.showActivityIndicator()
				}
			}
		}
	}
	
	func didFinishDataRequestWithData(receivedData: NSData) {
		let datastoreManager = DatastoreManager(delegate: self)
		let parser = JSONParser(rawData: receivedData)
		if parser.dataType == JSONParser.dataTypes.component {
			if self.system != nil {
				let components = parser.parseComponents(self.system!)
				datastoreManager.store(components)
			}
		} else if parser.dataType == JSONParser.dataTypes.empty {
			if self.system != nil {
				datastoreManager.deleteObjectsForEntity(ComponentManagedObject.entityName)
			}
		}
	}
	
	func didFinishDataRequest() {
		if self.refreshControl != nil {
			if self.refreshControl!.refreshing {
				self.refreshControl!.endRefreshing()
			}
		}
		
		Async.main {
			self.hideActivityIndicator()
		}
	}
	
	func didFinishDataRequestWithError(error: NSError) {
		Async.main {
			print(self.remoteConnectionManager!.messageForError(error))
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Fetching Remote Data", message: "An error occured while fetching data from the server. Please try agian.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
				self.presentingAlert = true
				self.presentViewController(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
}

// MARK: - Datastore Manager Delegate Methods

extension ComponentsTableViewController : DatastoreManagerDelegate {
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
	func didFinishStoringWithError(error: NSError) {
		Async.main {
			print("Error Storing Components")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
				self.presentingAlert = true
				self.presentViewController(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
}

// MARK: - Search Bar Methods

extension ComponentsTableViewController : UISearchBarDelegate {
	
	func initializeSearchController() {
		self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.dimsBackgroundDuringPresentation = true
		self.searchController.definesPresentationContext = true
		self.searchController.searchBar.delegate = self
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height)
	}
	
	func clearSearch() {
		self.searchPhrase = nil
		self.fetchedResultsController?.fetchRequest.predicate = self.defaultSearchPredicate
		self.fetchResultsWithReload(true)
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {
			var predicates = [NSPredicate]()
			self.searchPhrase = searchText
			if let predicate = self.defaultSearchPredicate {
				predicates.append(predicate)
			}
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", ComponentManagedObject.propertyKeys.name, searchText)
			predicates.append(filterPredicate)
			let fullPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
			self.fetchedResultsController?.fetchRequest.predicate = fullPredicate
			self.fetchResultsWithReload(true)
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