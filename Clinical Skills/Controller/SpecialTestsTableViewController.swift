//
//  SpecialTestsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import BRYXBanner

class SpecialTestsTableViewController : UITableViewController {
	
	// MARK: - Properties
	
	var parentComponent: Component?
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var datastoreManager: DatastoreManager?
	var remoteConnectionManager: RemoteConnectionManager?
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if self.parentComponent != nil {
			self.fetchedResultsController = SpecialTestsFetchedResultsController.specialTestsFetchedResultsController(self.parentComponent!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: Selector("handleRefresh"), forControlEvents: .ValueChanged)
			
			self.initializeSearchController()
			self.initializeActivityIndicator()
			
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			if let count = self.fetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchSpecialTests(forComponent: self.parentComponent!)
			}
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
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightSemibold)
		if let managedSpecialTest = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? SpecialTestManagedObject {
			cell.textLabel?.text = managedSpecialTest.name
		} else {
			cell.textLabel?.text = "Error Fetching Special Test"
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let managedSpecialTest = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? SpecialTestManagedObject {
			self.performSegueWithIdentifier(StoryboardSegueIdentifiers.toSpecialTestsDetailView.rawValue, sender: managedSpecialTest)
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
			print("Error occurred during Special Test fetch")
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchSpecialTests(forComponent: self.parentComponent!)
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
		if let managedSpecialTest = sender as? SpecialTestManagedObject {
			if let destination = segue.destinationViewController as? SpecialTestDetailTableViewController {
				destination.parentSpecialTest = SpecialTest.specialTestFromManagedObject(managedSpecialTest)
			}
		}
	}
	
}

// MARK: - Remote Connection Manager Delegate Methods

extension SpecialTestsTableViewController : RemoteConnectionManagerDelegate {
	
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
		let parser = JSONParser(rawData: receivedData)
		if parser.dataType == JSONParser.dataTypes.specialTest {
			if self.parentComponent != nil {
				let specialTests = parser.parseSpecialTests(self.parentComponent!)
				self.datastoreManager!.storeSpecialTests(specialTests)
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

extension SpecialTestsTableViewController : DatastoreManagerDelegate {

	func didFinishStoring() {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.fetchResultsWithReload(true)
		}
	}
	
}

// MARK: - Search Bar Methods

extension SpecialTestsTableViewController : UISearchBarDelegate {
	
	func initializeSearchController() {
		self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
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
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", SpecialTestManagedObject.propertyKeys.name, searchText)
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