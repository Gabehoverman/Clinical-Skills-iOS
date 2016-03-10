//
//  ComponentsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/9/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import BRYXBanner
import CoreData

class ComponentsTableViewController : UITableViewController {
	
	var parentSystem: System?
	
	var fetchedResultsController: NSFetchedResultsController?
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	
	var datastoreManager: DatastoreManager?
	var remoteConnectionManager: RemoteConnectionManager?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
	
	var isInitialLoad: Bool = true
	
	override func viewWillAppear(animated: Bool) {
		if self.isInitialLoad {
			if self.parentSystem != nil {
				self.fetchedResultsController = ComponentsFetchedResultsControllers.componentsFetchedResultsController(self.parentSystem!, delegateController: self)
				self.datastoreManager = DatastoreManager(delegate: self)
				self.remoteConnectionManager = RemoteConnectionManager(shouldRequestFromLocal: UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost), delegate: self)
				self.remoteConnectionManager!.fetchComponents(self.parentSystem!)
			}
		}
	}
	
	override func viewDidLoad() {
		if self.fetchedResultsController != nil {
			self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
		}
		self.refreshControl?.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: .ValueChanged)
		self.initializeSearchController()
		self.initializeActivityIndicator()
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.isInitialLoad = false
	}
	
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
		let cell = tableView.dequeueReusableCellWithIdentifier("ComponentTableViewCell") as! ComponentTableViewCell
		if let managedComponent = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? ComponentManagedObject {
			cell.componentNameLabel.text = managedComponent.name
		} else {
			cell.componentNameLabel.text = "Error Fetching Component Name"
		}
		return cell
	}
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error occurred during Component fetch")
		}
	}
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchComponents(self.parentSystem!)
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
	
}

extension ComponentsTableViewController : NSFetchedResultsControllerDelegate {
	
}

extension ComponentsTableViewController : DatastoreManagerDelegate {
	func didFinishStoring() {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.fetchResultsWithReload(true)
		}
	}
}

extension ComponentsTableViewController : RemoteConnectionManagerDelegate {
	
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
			self.datastoreManager!.storeSystems(parser.parseSystems())
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.showNetworkStatusBanner()
			})
		} else if parser.dataType == JSONParser.dataTypes.component {
			if self.parentSystem != nil {
				let components = parser.parseComponents(self.parentSystem!)
				self.datastoreManager!.storeComponents(components)
			}
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

extension ComponentsTableViewController : UISearchBarDelegate {
	
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