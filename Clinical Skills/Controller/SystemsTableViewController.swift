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
import Async

class SystemsTableViewController: UITableViewController {
	
	// MARK: - Properties
	

    @IBOutlet weak var OfflineUIView: UIView!
    @IBOutlet weak var OfflineButton: UIButton!
	var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
	
	var searchController: UISearchController?
	var activityIndicator: UIActivityIndicatorView?
	var presentingAlert: Bool = false
	
	var remoteConnectionManager: RemoteConnectionManager?
	
	var searchPhrase: String?
	var defaultSearchPredicate: NSPredicate?
    
    let blackView = UIView();
	
	// MARK: - View Controller Methodsq
	
	override func viewDidLoad() {
        
        self.OfflineUIView.isHidden = true
        
        backgroundDim()
		
		self.fetchedResultsController = FetchedResultsControllers.allSystemsFetchedResultController()
		self.fetchResultsWithReload(false)
		
		self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
		
		self.initializeSearchController()
		self.initializeActivityIndicator()
		
		self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
		
		self.remoteConnectionManager?.fetchSystems()
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        
        dismissBackgroundDim()
	}
    
   
    
    func backgroundDim() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            window.addSubview(blackView)
            blackView.frame = view.frame
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 180, y: 300)
            label.textAlignment = .center
            label.textColor = .white
            label.text = "Loading Clinical Skills"
            blackView.addSubview(label)
            
            let spinner = UIActivityIndicatorView()
            spinner.center = CGPoint(x:180 , y: 260)
            spinner.startAnimating()
            spinner.color = .green
            spinner.activityIndicatorViewStyle = .whiteLarge
            blackView.addSubview(spinner)
        }
        
    }
    
    func dismissBackgroundDim() {
        blackView.isHidden = true
    }
    
    //Not in use
    func offlineModeView() {
        let offlineView = UIView()
        offlineView.frame = view.frame
        view.addSubview(offlineView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 180, y: 300)
        label.text = "Your Application Appears to be Offline"
        label.numberOfLines = 2
        offlineView.addSubview(label)
        
        let button = UIButton()
        button.center = CGPoint(x: 180, y: 300)
        offlineView.addSubview(button)
    
    }
	
	// MARK: - Core Data Notification Methods
	
	func backgroundManagedObjectContextDidSave(_ saveNotification: Notification) {
		Async.main {
			if let workingContext = self.fetchedResultsController?.managedObjectContext {
				workingContext.mergeChanges(fromContextDidSave: saveNotification)
			}
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
		let managedSystem = self.fetchedResultsController!.object(at: indexPath) as! SystemManagedObject
		let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .byWordWrapping
		cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
		cell.textLabel?.text = managedSystem.name
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.tintColor = UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.0)
        cell.imageView?.image = UIImage(named: managedSystem.name + "Icon")
        //cell.detailTextLabel?.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        
        cell.detailTextLabel?.text = managedSystem.name + " tests and inspection details"
        
        /*if (managedSystem.name == "Abdomen" ) {
            cell.detailTextLabel?.text = "Abdominal tests and inspection details"
        } else if (managedSystem.name == "Cardiovascular" ) {
            cell.detailTextLabel?.text = "Cardiovascular tests and inspection details"
        } else if (managedSystem.name == "Eye") {
            cell.detailTextLabel?.text = "Eye tests and inspection details"
        } else if (managedSystem.name == "Head, Ears, Nose, Neck, Throat") {
            cell.detailTextLabel?.text = "Head, Ears, Nose, Neck, and Throat tests and inspection details"
        } else if (managedSystem.name == "Musculoskeletal") {
            cell.detailTextLabel?.text = "Musculoskeletal tests and inspection details"
        } else if (managedSystem.name == "Neurological") {
            cell.detailTextLabel?.text = "Neuroligcal tests and inspection details"
        } else if (managedSystem.name == "Respiratory") {
            cell.detailTextLabel?.text = "Respiratory tests and inspection details"
        } else if (managedSystem.name == "Vital Signs" ) {
            cell.detailTextLabel?.text = "Vital Signs tests and inspection details"
        } else {
            
        }*/
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let controller = self.fetchedResultsController {
			if let managedSystem = controller.object(at: indexPath) as? SystemManagedObject {
				if self.tabBarController?.selectedIndex == StoryboardIdentifiers.tab.clinicalSkills {
                    //To Systems Menu Table View
					self.performSegue(withIdentifier: "toSystemMenu", sender: System(managedObject: managedSystem))
				} else {
                    //To Components List View
					self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toComponentsView, sender: System(managedObject: managedSystem))
				}
			} else {
				print("Error getting System")
			}
		} else {
			print("Error getting controller")
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
			print("Error Fetching Systems")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
                offlineModeView()
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
				self.presentingAlert = true
				self.present(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(_ refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchSystems()
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
	
	// MARK: - Navigation Methods
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == StoryboardIdentifiers.segue.toComponentFile {
			if let destination = segue.destination as? ComponentFileController {
				if let system = sender as? System {
					destination.system = system
				}
			}
        
		} else if segue.identifier == "toSystemMenu" {
			if let destination = segue.destination as? SystemMenuViewController {
				if let system = sender as? System {
					destination.system = system
				}
			}
        }
	}
}

// MARK: - Remote Connection Manager Delegate Methods

extension SystemsTableViewController: RemoteConnectionManagerDelegate {
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
		if parser.dataType == JSONParser.dataTypes.system {
			let systems = parser.parseSystems()
			datastoreManager.store(systems)
		} else if parser.dataType == JSONParser.dataTypes.empty {
			datastoreManager.deleteObjectsForEntity(SystemManagedObject.entityName)
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
                //self.offlineModeView()
                self.OfflineUIView.isHidden = false;
				let alertController = UIAlertController(title: "Error Fetching Remote Data", message: "An error occured while fetching data from the server. Please try agian.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
				self.presentingAlert = true
				self.present(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
}

// MARK: - Datastore Manager Delegate Methods

extension SystemsTableViewController: DatastoreManagerDelegate {
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
	func didFinishStoringWithError(_ error: NSError) {
		Async.main {
			print("Error Storing Systems")
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

// MARK: - Search Delegate Methods

extension SystemsTableViewController: UISearchBarDelegate {
	func initializeSearchController() {
		self.defaultSearchPredicate = self.fetchedResultsController!.fetchRequest.predicate
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController?.dimsBackgroundDuringPresentation = true
		self.searchController?.definesPresentationContext = true
		self.searchController?.searchBar.delegate = self
		self.tableView.tableHeaderView = self.searchController?.searchBar
		self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController!.searchBar.frame.size.height)
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
			let filterPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", SystemManagedObject.propertyKeys.name, searchText)
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
