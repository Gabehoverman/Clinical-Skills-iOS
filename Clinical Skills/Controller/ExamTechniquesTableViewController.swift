//
//  ExamTechniquesTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import BRYXBanner
import Async

class ExamTechniquesTableViewController : UITableViewController {
	
	// MARK: - Properties
	
	var system: System?
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	
	var datastoreManager: DatastoreManager?
	var remoteConnectionManager: RemoteConnectionManager?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if self.system != nil {
			self.fetchedResultsController = ExamTechniquesFetchedResultsControllers.examTechniquesFetchedResultsController(self.system!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
			
			self.initializeSearchController()
			self.initializeActivityIndicator()
			
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			if let count = self.fetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchExamTechniques(forSystem: self.system!)
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
		} else {
			return 0
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightSemibold)
		if let managedExamTechnique = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? ExamTechniqueManagedObject {
			cell.textLabel?.text = managedExamTechnique.name
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if self.fetchedResultsController != nil {
			if let managedExamTechnique = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? ExamTechniqueManagedObject {
				self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toExamTechniquesDetailsView, sender: managedExamTechnique)
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
			print("Error occurred during Exam Technique fetch")
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchExamTechniques(forSystem: self.system!)
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
		if segue.identifier == StoryboardIdentifiers.segue.toExamTechniquesDetailsView {
			if let destination = segue.destinationViewController as? ExamTechniqueDetailsTableViewController {
				if let managedExamTechnique = sender as? ExamTechniqueManagedObject {
					destination.examTechnique = ExamTechnique.examTechniqueFromManagedObject(managedExamTechnique)
				}
			}
		}
	}
	
}

// MARK: - Remote Connection Manager Delegate Methods

extension ExamTechniquesTableViewController : RemoteConnectionManagerDelegate {
	
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
		let parser = JSONParser(rawData: receivedData)
		if parser.dataType == JSONParser.dataTypes.examTechnique {
			if self.system != nil {
				let examTechniques = parser.parseExamTechniques(self.system!)
				self.datastoreManager!.storeExamTechniques(examTechniques)
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
	
	func showRequestStatusBanner() {
		Async.main {
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
}

// MARK: - Datastore Manager Delegate Methods

extension ExamTechniquesTableViewController : DatastoreManagerDelegate {
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
}

// MARK: - Search Bar Methods

extension ExamTechniquesTableViewController : UISearchBarDelegate {
	
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
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", ExamTechniqueManagedObject.propertyKeys.name, searchText)
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