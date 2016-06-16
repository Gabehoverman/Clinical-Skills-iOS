//
//  PersonnelAcknowledgementTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Async

class PersonnelAcknowledgementTableViewController : UITableViewController {
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var searchController: UISearchController!
	var activityIndicator: UIActivityIndicatorView?
	var presentingAlert: Bool = false
	
	var remoteConnectionManager: RemoteConnectionManager?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
	
	override func viewDidLoad() {
		self.fetchedResultsController = FetchedResultsControllers.allPersonnelAcknowledgementsFetchedResultController()
		self.fetchResultsWithReload(false)
		
		self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
		
		self.initializeSearchController()
		self.initializeActivityIndicator()
		
		self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
		
		self.remoteConnectionManager!.fetchPersonnelAcknowledgements()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = self.fetchedResultsController?.fetchedObjects?.count where count != 0 {
			return count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let managedPersonnelAcknowledgement = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? PersonnelAcknowledgementManagedObject {
			if let cell = self.tableView.dequeueReusableCellWithIdentifier(StoryboardIdentifiers.cell.personnelAcknowledgementCell) as? PersonnelAcknowledgementTableViewCell {
				cell.nameLabel.numberOfLines = 1
				cell.nameLabel.adjustsFontSizeToFitWidth = true
				cell.nameLabel.text = managedPersonnelAcknowledgement.name
				cell.roleLabel.numberOfLines = 1
				cell.roleLabel.adjustsFontSizeToFitWidth = true
				cell.roleLabel.text = managedPersonnelAcknowledgement.role
                cell.notesLabel.numberOfLines = 5
				cell.notesLabel.text = managedPersonnelAcknowledgement.notes
				return cell
			}

		}
		return UITableViewCell()
	}
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error Fetching Personnel Acknowledgements")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
				self.presentingAlert = true
				self.presentViewController(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
	
	func backgroundManagedObjectContextDidSave(saveNotification: NSNotification) {
		Async.main {
			if let workingContext = self.fetchedResultsController?.managedObjectContext {
				workingContext.mergeChangesFromContextDidSaveNotification(saveNotification)
			}
		}
	}
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager?.fetchPersonnelAcknowledgements()
	}
	
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

extension PersonnelAcknowledgementTableViewController : RemoteConnectionManagerDelegate {
	
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
		if parser.dataType == JSONParser.dataTypes.personnel_acknowledgement {
			let personnelAcknowledgements = parser.parsePersonnelAcknowledgements()
			datastoreManager.store(personnelAcknowledgements)
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

extension PersonnelAcknowledgementTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
	func didFinishStoringWithError(error: NSError) {
		Async.main {
			print("Error Storing Personnel Acknowledgements")
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

extension PersonnelAcknowledgementTableViewController : UISearchBarDelegate {
	
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
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", PersonnelAcknowledgementManagedObject.propertyKeys.name, searchText)
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