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
	
	// MARK: - Class Constants
	
	static let storyboardIdentifier = "SystemsTableViewController"
	
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
			self.fetchedResultsController = SystemFetchedResultsControllers.allSystemsResultController(self)
			self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(shouldRequestFromLocal: UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost), delegate: self)
			self.remoteConnectionManager!.fetchSystems()
		}
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("defaultsChanged"), name: NSUserDefaultsDidChangeNotification, object: nil)
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
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UserDefaultsManager.userDefaultsKeys.requestFromLocalHost, object: nil)
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
		let managedSystem = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! SystemManagedObject
		let cell = UITableViewCell()
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightSemibold)
		cell.textLabel?.text = managedSystem.name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let managedSystem = controller.objectAtIndexPath(indexPath) as? SystemManagedObject {
				self.performSegueWithIdentifier(StoryboardSegueIdentifiers.toComponentsView.rawValue, sender: System.systemFromManagedObject(managedSystem))
			} else {
				print("Error getting System")
			}
		} else {
			print("Error getting controller")
		}
	}
	
	// MARK: - Refresh Methods
	
	func fetchResultsWithReload(shouldReload: Bool) {
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
		alert.addAction(UIAlertAction(title: "Nevermind", style: .Cancel) { (action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
			}
		)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	// MARK: - NSNotification Observeration Methods
	
	func remoteConnectionFetchLocationChanged(notification: NSNotification) {
		if let newValue = notification.object as? Bool {
			self.remoteConnectionManager!.shouldRequestFromLocal = newValue
		}
	}
	
	// MARK: - Navigation Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryboardSegueIdentifiers.toComponentsView.rawValue {
			if let destination = segue.destinationViewController as? ComponentsTableViewController {
				if let system = sender as? System {
					destination.navigationItem.title = system.name
					destination.parentSystem = system
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
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", SystemManagedObject.propertyKeys.name, searchText)
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

// MARK: - Remote Connection Manager Delegate Methods

extension SystemsTableViewController: RemoteConnectionManagerDelegate {
	func didBeginDataRequest() {
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
			let systems = parser.parseSystems()
			self.datastoreManager!.storeSystems(systems)
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.showNetworkStatusBanner()
			})
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
			self.showNetworkStatusBanner()
		}
	}
	
	func showNetworkStatusBanner() {
		var color = UIColor.whiteColor()
		if self.remoteConnectionManager!.statusSuccess {
			color = UIColor(red: 90.0/255.0, green: 212.0/255.0, blue: 39.0/255.0, alpha: 0.95)
		} else {
			color = UIColor(red: 255.0/255.0, green: 80.0/255.0, blue: 44.0/255.0, alpha: 0.95)
		}
		let banner = Banner(title: "HTTP Response", subtitle: self.remoteConnectionManager!.statusMessage, image: nil, backgroundColor: color, didTapBlock: nil)
		banner.dismissesOnSwipe = true
		banner.dismissesOnTap = true
		banner.show(self.navigationController!.view, duration: 1.5)
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

extension SystemsTableViewController {
	func defaultsChanged() {
		remoteConnectionManager!.shouldRequestFromLocal = UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost)
	}
}