//
//  VideoTableViewController.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 8/30/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Async

class VideoTableViewController: UITableViewController {
    
    
    let vid1 = Video(id: 1, title: "Abdomenal Auscultation", url:"https://www.youtube.com/embed/HNkP2CKT3t4", descrip: "This is the description for the video")
    let vid2 = Video(id: 2, title: "Vascular Auscultation", url:"https://www.youtube.com/embed/F1_iV8BQQm4", descrip: "This is the description for the video")
    let vid3 = Video(id: 3, title: "Percussion", url:"https://www.youtube.com/embed/g7DiUnuOzcc", descrip: "This is the description for the video")
    let vid4 = Video(id: 4, title: "Liver Percussion", url:"https://www.youtube.com/embed/D0G7353qfYw", descrip: "This is the description for the video")
    let vid5 = Video(id: 5, title: "Spleen Percussion", url:"https://www.youtube.com/embed/_fAWTNvoLZs", descrip: "This is the description for the video")
    let vid6 = Video(id: 6, title: "Kidney Percussion", url:"https://www.youtube.com/embed/sNNIhg1v2s8", descrip: "This is the description for the video")
    let vid7 = Video(id: 7, title: "Palpation", url:"https://www.youtube.com/embed/inAjKzaopj0", descrip: "This is the description for the video")
    let vid8 = Video(id: 8, title: "Liver Palpation", url:"https://www.youtube.com/embed/InMJRyDjOFQ", descrip: "This is the description for the video")
    let vid9 = Video(id: 9, title: "Spleen Palpation", url:"https://www.youtube.com/embed/d5XABa0tTyg", descrip: "This is the description for the video")
    let vid10 = Video(id: 10, title: "Kidney Palpation", url:"https://www.youtube.com/embed/b_IINTReCnc", descrip: "This is the description for the video")
    let vid11 = Video(id: 11, title: "Aorta Palpation", url:"https://www.youtube.com/embed/jIUzYQ_I-bU", descrip: "This is the description for the video")
    let vid12 = Video(id: 12, title: "Rebound Tenderness", url:"https://www.youtube.com/embed/YYIoxjiBAV0", descrip: "This is the description for the video")
    let vid13 = Video(id: 12, title: "Iliopsoas Muscle Test", url:"https://www.youtube.com/embed/-azrl9gRUMU", descrip: "This is the description for the video")
    let vid14 = Video(id: 12, title: "Murphy's Sign", url:"https://www.youtube.com/embed/Uk0zQUZphlI", descrip: "This is the description for the video")
    let vid15 = Video(id: 12, title: "Obturator Muscle Test", url:"https://www.youtube.com/embed/k6Pznq4VYoE", descrip: "This is the description for the video")
    
    
    var system: System?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var videoLinksFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var searchController: UISearchController!
    var activityIndicator: UIActivityIndicatorView?
    var presentingAlert: Bool = false
    
    var remoteConnectionManager: RemoteConnectionManager?
    
    var searchPhrase: String?
    var defaultSearchPredicate: NSPredicate?
    
    override func viewDidLoad() {
        
        
            //self.fetchedResultsController = FetchedResultsControllers.videoLinksFetchedResultsController(self.system!)
        
            self.videoLinksFetchedResultsController = FetchedResultsControllers.videoLinksFetchedResultsController(self.system!)
            self.fetchResultsWithReload(false)
            
            self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
            
            self.initializeSearchController()
            self.initializeActivityIndicator()
            
            self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
            
            self.remoteConnectionManager?.fetchSystemVideoLinks(forSystem: self.system!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count {
            print(count)
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Hardcoded array */
        let tabArr:[Video] = [vid1, vid2, vid3, vid4, vid5, vid6, vid7, vid8, vid9, vid10, vid11, vid12, vid13, vid14, vid15]
        
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        //cell.textLabel?.text = tabArr[indexPath.item].title
        if let managedVideoLink = self.videoLinksFetchedResultsController?.object(at: indexPath) as? VideoLinkManagedObject {
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = managedVideoLink.title
        } else {
            cell.textLabel?.text = "Error Fetching Component Name"
        }
        return cell
    }
    
    /**override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabArr:[Video] = [vid1, vid2, vid3, vid4, vid5, vid6, vid7, vid8, vid9, vid10, vid11, vid12, vid13, vid14, vid15]
        //self.DocPreview(tabArr[indexPath.item])
        self.performSegue(withIdentifier: "toVideoPlayer", sender: self.videoLinksFetchedResultsController?.object(at: indexPath))
    }**/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVideoPlayer" {
            if let destination = segue.destination as? VideoPlayerViewController {
                if let video = sender as? VideoLinkManagedObject {
                    destination.video = video
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let fixedSectionIndexPath = IndexPath(row: indexPath.row, section: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
            if let managedVideoLink = self.videoLinksFetchedResultsController?.object(at: fixedSectionIndexPath) as? VideoLinkManagedObject {
                self.performSegue(withIdentifier: "toVideoPlayer", sender: managedVideoLink)
            }
    }
    
    
    // MARK: - Fetch Methods
    
    func fetchResultsWithReload(_ shouldReload: Bool) {
        do {
            try self.videoLinksFetchedResultsController!.performFetch()
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
            if let workingContext = self.videoLinksFetchedResultsController?.managedObjectContext {
                workingContext.mergeChanges(fromContextDidSave: saveNotification)
            }
        }
    }
    
    // MARK: - Refresh Methods
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.remoteConnectionManager!.fetchSystemVideoLinks(forSystem: self.system!)
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
    
    func ParseJsonArrayTest() {
        print("Begin Parsing Array")
        let url = URL(string: "http://localhost:3000/video_links?system=abdomen&format=json")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("error")
            }
            else {
                if let content = data
                {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print("finished parsing json")
                        
                        print(myJson)
                    }
                    catch {
                        
                    }
                }
            }
        
        }
        task.resume()
    }
    
    /**override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    }**/

    
    
}

extension VideoTableViewController : RemoteConnectionManagerDelegate {
    
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
        if parser.dataType == JSONParser.dataTypes.videoLink {
            let videoLinks = parser.parseVideoLinks(self.system!)
            datastoreManager.store(videoLinks)

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

extension VideoTableViewController : DatastoreManagerDelegate {
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

extension VideoTableViewController : UISearchBarDelegate {
    
    func initializeSearchController() {
        self.defaultSearchPredicate = self.videoLinksFetchedResultsController!.fetchRequest.predicate
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
