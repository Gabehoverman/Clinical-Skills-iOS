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
	
	var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
	
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
		
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
			
			self.initializeSearchController()
			self.initializeActivityIndicator()
			
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			self.remoteConnectionManager?.fetchComponents(forSystem: self.system!)
		
			NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
            
            
		}
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = self.fetchedResultsController?.fetchedObjects?.count {
			return count
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .byWordWrapping
		cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
		if let managedComponent = self.fetchedResultsController?.object(at: indexPath) as? ComponentManagedObject {
			cell.textLabel?.text = managedComponent.name
		} else {
			cell.textLabel?.text = "Error Fetching Component Name"
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if self.fetchedResultsController != nil {
			if let managedComponent = self.fetchedResultsController!.object(at: indexPath) as? ComponentManagedObject {
				if self.tabBarController?.selectedIndex == StoryboardIdentifiers.tab.clinicalSkills {
					self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toComponentDetailsView, sender: managedComponent) //Orginially toComponentFile
				} else {
					self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toComponentDetailsView, sender: managedComponent) //toSpecialTestsView originally
				}
			}
		}
	}
	
	// MARK: - Fetch Methods
	
	func fetchResultsWithReload(_ shouldReload: Bool) {
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error Fetching Components")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
				self.presentingAlert = true
				self.present(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
	
	// MARK: - Core Data Notification Methods
	
	func backgroundManagedObjectContextDidSave(_ saveNotification: Notification) {
		Async.main {
			if let workingContext = self.fetchedResultsController?.managedObjectContext {
				workingContext.mergeChanges(fromContextDidSave: saveNotification)
			}
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(_ refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchComponents(forSystem: self.system!)
	}
	
	// MARK: - Activity Indicator Methods
	
	func initializeActivityIndicator() {
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		self.activityIndicator!.center = self.tableView.center
		self.activityIndicator!.hidesWhenStopped = true
		self.view.addSubview(self.activityIndicator!)
		self.activityIndicator!.bringSubview(toFront: self.view)
	}
	
	func showActivityIndicator() {
		self.activityIndicator!.startAnimating()
	}
	
	func hideActivityIndicator() {
		self.activityIndicator!.stopAnimating()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == StoryboardIdentifiers.segue.toComponentDetailsView {
			if let destination = segue.destination as? ComponentDetailsTableViewController {
				/*if let managedComponent = sender as? ComponentManagedObject {
					destination.component = Component(managedObject: managedComponent)
				}*/
			}
		} else if segue.identifier == StoryboardIdentifiers.segue.toSpecialTestsView {
			if let destination = segue.destination as? SpecialTestsTableViewController {
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
			if !self.refreshControl!.isRefreshing {
				Async.main {
					self.showActivityIndicator()
				}
			}
		}
	}
	
	func didFinishDataRequestWithData(_ receivedData: Data) {
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
			if self.refreshControl!.isRefreshing {
				self.refreshControl!.endRefreshing()
			}
		}
		
		Async.main {
			self.hideActivityIndicator()
		}
	}
	
	func didFinishDataRequestWithError(_ error: NSError) {
		Async.main {
			print(self.remoteConnectionManager!.messageForError(error))
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Fetching Remote Data", message: "An error occured while fetching data from the server. Please try agian.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
				self.presentingAlert = true
				self.present(alertController, animated: true, completion: { self.presentingAlert = false })
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
	
	func didFinishStoringWithError(_ error: NSError) {
		Async.main {
			print("Error Storing Components")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
				self.presentingAlert = true
				self.present(alertController, animated: true, completion: { self.presentingAlert = false })
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
		self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController.searchBar.frame.size.height)
	}
	
	func clearSearch() {
		self.searchPhrase = nil
		self.fetchedResultsController?.fetchRequest.predicate = self.defaultSearchPredicate
		self.fetchResultsWithReload(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.clearSearch()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.text = self.searchPhrase
	}
}
