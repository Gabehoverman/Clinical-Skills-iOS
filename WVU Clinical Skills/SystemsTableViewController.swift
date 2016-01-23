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
import BRYXBanner

/**
	Table View displaying all System data inside the database
*/
class SystemsTableViewController: UITableViewController {
	
	// MARK: - Properties
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	var fetchedResultsController: NSFetchedResultsController?
	
	var remoteConnectionManager: RemoteConnectionManager?
	var datastoreManager: DatastoreManager?
	
	var isInitialLoad = true
	
	var defaultSearchPredicate: NSPredicate?
	var searchPhrase: String?
	
	// MARK: - View Controller Methods
	
	override func viewWillAppear(animated: Bool) {
		if self.isInitialLoad {
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(shouldRequestFromLocal: false, delegate: self)
			self.remoteConnectionManager!.fetchSystems()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.searchController = UISearchController(searchResultsController: nil)
		self.refreshControl?.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: .ValueChanged)
		self.initializeSearchController()
		self.initializeActivityIndicator()
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
		let cell = tableView.dequeueReusableCellWithIdentifier(SystemTableViewCell.systemCellIdentifier) as! SystemTableViewCell
		let managedSystem = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! SystemManagedObject
		cell.systemNameLabel.text = managedSystem.name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let managedSystem = controller.objectAtIndexPath(indexPath) as? SystemManagedObject {
				if managedSystem.subsystems.count == 0 {
					performSegueWithIdentifier(StoryboardSegueIdentifiers.ToDetailsView.rawValue, sender: managedSystem)
				} else {
					performSegueWithIdentifier(StoryboardSegueIdentifiers.ToSubsystemView.rawValue, sender: managedSystem)
				}
			} else {
				print("Error getting System")
			}
		} else {
			print("Error getting controller")
		}
	}
	
	// MARK: - Refresh Methods
	
	func fetchResultsWithReload(shouldReload: Bool) {
		if self.fetchedResultsController == nil {
			self.fetchedResultsController = SystemFetchedResultsControllers.allVisibleSystemsResultController(self)
			self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
		}
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error occurred during System fetch")
		}
	}
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchSystems()
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
	
	// MARK: - User Interface Actions
	
	@IBAction func clear(sender: AnyObject) {
		let alert = UIAlertController(title: "Clear", message: "What should be cleared?", preferredStyle: .ActionSheet)
		alert.addAction(UIAlertAction(title: "Clear All", style: .Destructive) { (action) -> Void in
			(UIApplication.sharedApplication().delegate as! AppDelegate).clearAll()
			}
		)
		alert.addAction(UIAlertAction(title: "Clear Systems", style: .Default) { (action) -> Void in
			(UIApplication.sharedApplication().delegate as! AppDelegate).clearSystems()
			}
		)
		alert.addAction(UIAlertAction(title: "Clear Subsystems", style: .Default) { (action) -> Void in
			(UIApplication.sharedApplication().delegate as! AppDelegate).clearSubsystems()
			}
		)
		alert.addAction(UIAlertAction(title: "Clear Links", style: .Default) { (action) -> Void in
			(UIApplication.sharedApplication().delegate as! AppDelegate).clearLinks()
			}
		)
		alert.addAction(UIAlertAction(title: "Nevermind", style: .Cancel) { (action) -> Void in
			self.fetchResultsWithReload(true)
			self.dismissViewControllerAnimated(true, completion: nil)
			}
		)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	@IBAction func printManagedObjects(sender: AnyObject) {
		let alert = UIAlertController(title: "Print", message: "What should be printed?", preferredStyle: .ActionSheet)
		alert.addAction(UIAlertAction(title: "Print All", style: .Destructive) { (action) -> Void in
			self.datastoreManager!.printContents()
			}
		)
		alert.addAction(UIAlertAction(title: "Print Systems", style: .Default) { (action) -> Void in
			self.datastoreManager!.printSystems()
			}
		)
		alert.addAction(UIAlertAction(title: "Print Subsystems", style: .Default) { (action) -> Void in
			self.datastoreManager!.printSubsystems()
			}
		)
		alert.addAction(UIAlertAction(title: "Print Links", style: .Default) { (action) -> Void in
			self.datastoreManager!.printLinks()
			}
		)
		alert.addAction(UIAlertAction(title: "Nevermind", style: .Cancel) { (action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
			}
		)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	// MARK: - Navigation Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let managedSystem = sender as? SystemManagedObject {
			if segue.identifier == StoryboardSegueIdentifiers.ToDetailsView.rawValue {
				if let destination = segue.destinationViewController as? SystemDetailViewController {
					destination.navigationItem.title = managedSystem.name
					destination.managedSystem = managedSystem
				}
			} else if segue.identifier == StoryboardSegueIdentifiers.ToSubsystemView.rawValue {
				if let destination = segue.destinationViewController as? SubsystemsTableViewController {
					destination.navigationItem.title = managedSystem.name
					destination.managedParentSystem = managedSystem
				}
			}
		}
	}
	
}

// MARK: - Fetched Results Controller Delegate Methods

extension SystemsTableViewController: NSFetchedResultsControllerDelegate {
	// No Methods Required Currently
}

// MARK: - Search Delegate Methods

extension SystemsTableViewController: UISearchBarDelegate {
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
		self.fetchResultsWithReload(true)
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {
			if self.defaultSearchPredicate != nil {
				self.searchPhrase = searchText
				var predicates = [self.defaultSearchPredicate!]
				let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", SystemManagedObject.propertyKeys.name, searchText)
				predicates.append(filterPredicate)
				let fullPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
				self.fetchedResultsController?.fetchRequest.predicate = fullPredicate
				self.fetchResultsWithReload(true)
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

// MARK: - Remote Connection Manager Delegate Methods

extension SystemsTableViewController: RemoteConnectionManagerDelegate {
	func didBeginDataRequest() {
		print("Requesting")
		if self.refreshControl != nil {
			if !self.refreshControl!.refreshing {
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.showActivityIndicator()
				})
			}
		}
	}
	
	func didFinishDataRequestWithData(receivedData: NSData) {
		let parser = JSONParser(jsonData: receivedData)
		if parser.dataType == JSONParser.dataTypes.system {
			self.datastoreManager!.storeSystems(parser.parseSystems())
			self.remoteConnectionManager!.fetchSubsystems()
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.showBanner()
			})
		} else if parser.dataType == JSONParser.dataTypes.subsystem {
			self.datastoreManager!.storeSubsystems(parser.parseSubsystems())
		}
	}
	
	func didFinishDataRequest() {
		if self.refreshControl != nil {
			if self.refreshControl!.refreshing {
				self.refreshControl!.endRefreshing()
			}
		}
		
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.fetchResultsWithReload(true)
			self.hideActivityIndicator()
		}
	}
	
	func showBanner() {
		var color = UIColor.whiteColor()
		if self.remoteConnectionManager!.statusSuccess {
			color = UIColor(red: 90.0/255.0, green: 212.0/255.0, blue: 39.0/255.0, alpha: 0.9)
		} else {
			color = UIColor(red: 255.0/255.0, green: 91.0/255.0, blue: 55.0/255.0, alpha: 0.9)
		}
		let banner = Banner(title: "HTTP Response", subtitle: self.remoteConnectionManager!.statusMessage, image: nil, backgroundColor: color, didTapBlock: nil)
		banner.show(self.navigationController?.view, duration: 1.5)
	}
}

// MARK: - Datastore Manager Delegate Methods

extension SystemsTableViewController: DatastoreManagerDelegate {
	func didFinishStoring() {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.fetchResultsWithReload(true)
		}
	}
}