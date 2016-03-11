//
//  SpecialTestDetailTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import CoreData
import BRYXBanner

class SpecialTestDetailTableViewController : UITableViewController {
	
	// MARK: - Properites
	
	var specialTest: SpecialTest?
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var remoteConnectionManager: RemoteConnectionManager?
	var datastoreManager: DatastoreManager?
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
	var isInitialLoad: Bool = true
	
	// MARK: - View Controller Methods
	
	override func viewWillAppear(animated: Bool) {
		if self.isInitialLoad {
			self.fetchedResultsController = VideoLinksFetchedResultsControllers.videoLinksFetchedResultsController(self.specialTest!)
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			self.remoteConnectionManager?.fetchVideoLinks(self.specialTest!)
		}
	}
	
	override func viewDidLoad() {
		self.refreshControl?.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: .ValueChanged)
		self.initializeSearchController()
		self.initializeActivityIndicator()
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.isInitialLoad = false
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
			case 0: return "Name"
			case 1: return "Positive Sign"
			case 2: return "Indication"
			case 3: return "Video Links"
			default: return  "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 3 {
			if let count = self.fetchedResultsController?.fetchedObjects?.count {
				return count
			} else {
				return 0
			}
		}
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.systemFontOfSize(16)
		switch (indexPath.section) {
			case 0: cell.textLabel?.text = self.specialTest?.name
			case 1: cell.textLabel?.text = self.specialTest?.positiveSign
			case 2: cell.textLabel?.text = self.specialTest?.indication
			case 3:
				if let managedVideoLink = self.fetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? VideoLinkManagedObject {
					cell.textLabel?.text = managedVideoLink.title
				}
			default: cell.textLabel?.text = ""
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 3 {
			let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
			if let managedVideoLink = self.fetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? VideoLinkManagedObject {
				if let url = NSURL(string: managedVideoLink.link) {
					let safariViewController = SFSafariViewController(URL: url)
					safariViewController.delegate = self
					self.presentViewController(safariViewController, animated: true, completion: nil)
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
			print("Error occurred during Video Links fetch")
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchVideoLinks(self.specialTest!)
	}
	
	// MARK: - Activity Indicator Methods
	
	func initializeActivityIndicator() {
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		self.activityIndicator!.center = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y * 1.5)
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

// MARK: - Remote Connection Manager Delegate Methods

extension SpecialTestDetailTableViewController : RemoteConnectionManagerDelegate {
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
		if parser.dataType == JSONParser.dataTypes.videoLink {
			if self.specialTest != nil {
				let videoLinks = parser.parseVideoLinks(self.specialTest!)
				self.datastoreManager?.storeVideoLinks(videoLinks)
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

// MARK: - Datastore Manager Delegate Methods

extension SpecialTestDetailTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.fetchResultsWithReload(true)
		}
		
		self.datastoreManager?.printAll()
	}
	
}

// MARK: - Search Bar Methods

extension SpecialTestDetailTableViewController : UISearchBarDelegate {
	
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
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", VideoLinkManagedObject.propertyKeys.title, searchText)
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

// MARK: - Safari View Controller Delegate Methods

extension SpecialTestDetailTableViewController : SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(controller: SFSafariViewController) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}