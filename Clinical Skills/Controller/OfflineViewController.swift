//
//  OfflineViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Async

class OfflineViewController: UITableViewController {
    
    /* Offline View Controller not in use. Offline Table View Controller is current controller. */
    
    // MARK: - Properties
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var searchController: UISearchController?
    var activityIndicator: UIActivityIndicatorView?
    var presentingAlert: Bool = false
    
    var remoteConnectionManager: RemoteConnectionManager?
    
    var searchPhrase: String?
    var defaultSearchPredicate: NSPredicate?
    
    
    //let tableComponents = ["Abdomen","Cardiovascular","Eye","Head,Ears, Nose, Neck, Throat","Musculoskeletal","Neurological","Respiratory","Vital Signs"];
    
    let Abdomen = System(id: 1, name:"Abdomen",details:"none")
    let Cardio = System(id: 2, name:"Cardiovascular", details:"none")
    let Eye = System(id:3, name:"Eye", details:"none")
    let Head = System(id:4, name:"Head, Ears, Nose, Neck, Throat", details:"none")
    let Musc = System(id:5, name:"Musculoskeletal", details:"none")
    let Neur = System(id:6, name:"Neurological", details:"none")
    let Resp = System(id:7, name:"Respiratory", details:"none")
    let Vita = System(id:8, name:"Vital Signs", details:"none")
    
    // MARK: - View Controller Methodsq
    
    override func viewDidLoad() {
        
        self.fetchedResultsController = FetchedResultsControllers.allSystemsFetchedResultController()
        //self.fetchResultsWithReload(false)
        
        //self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        
        self.initializeActivityIndicator()
        
        self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
        
        self.remoteConnectionManager?.fetchSystems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
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
        
        /* Hardcoded array */
        let tabArr:[System] = [Abdomen, Cardio, Eye, Head, Musc, Neur, Resp, Vita]
        
        /* Fetches data sever*/
        //let managedSystem = self.fetchedResultsController!.object(at: indexPath) as! SystemManagedObject
        
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        cell.textLabel?.text = tabArr[indexPath.item].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabArr:[System] = [Abdomen, Cardio, Eye, Head, Musc, Neur, Resp, Vita]
        if self.tabBarController?.selectedIndex == StoryboardIdentifiers.tab.clinicalSkills {
            self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toComponentFile, sender: tabArr[indexPath.item])
        } else {
            self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toComponentFile, sender: tabArr[indexPath.item])
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
            /*
             } else if segue.identifier == StoryboardIdentifiers.segue.toComponentFile {
             if let destination = segue.destination as? ComponentFileController {
             if let system = sender as? System {
             destination.system = system
             }
             }
            */
            
        }
    }
}

// MARK: - Remote Connection Manager Delegate Methods

extension OfflineViewController: RemoteConnectionManagerDelegate {
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
                let alertController = UIAlertController(title: "Error Fetching Remote Data", message: "An error occured while fetching data from the server. Please try agian.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.presentingAlert = true
                self.present(alertController, animated: true, completion: { self.presentingAlert = false })
            }
        }
    }
}

// MARK: - Datastore Manager Delegate Methods

extension OfflineViewController: DatastoreManagerDelegate {
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

extension OfflineViewController: UISearchBarDelegate {
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
