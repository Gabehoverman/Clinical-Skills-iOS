//
//  DetailOverviewViewController.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 8/30/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit
import Async
import CoreData

class DetailOverviewViewController: UITableViewController {
    
    var component: Component?
    
    var palpationsFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var rangesOfMotionFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var musclesFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var specialTestsFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var remoteConnectionManager: RemoteConnectionManager?
    
    var activityIndicator: UIActivityIndicatorView?
    var presentingAlert: Bool = false
  
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        if (self.component != nil) {
            self.palpationsFetchedResultsController = FetchedResultsControllers.palpationsFetchedResultsController(forComponent: self.component!)
            self.rangesOfMotionFetchedResultsController = FetchedResultsControllers.rangesOfMotionFetchedResultsController(forComponent: self.component!)
            self.musclesFetchedResultsController = FetchedResultsControllers.musclesFetchedResultsController(forComponent: self.component!)
            self.specialTestsFetchedResultsController = FetchedResultsControllers.specialTestsFetchedResultsController(self.component!)
            self.fetchResultsWithReload(false)
            
            self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
            
            self.initializeActivityIndicator()
            
            self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
            
            self.remoteConnectionManager?.fetchPalpations(forComponent: self.component!)
            
            self.remoteConnectionManager?.fetchRangesOfMotion(forComponent: self.component!)
            
            self.remoteConnectionManager?.fetchMuscles(forComponent: self.component!)
            
            self.remoteConnectionManager?.fetchSpecialTests(forComponent: self.component!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
            
            
        }
    }
    
    
    // MARK: - Collapsable Table Sections
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Table View Controller Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0: return "Inspection"
        case 1: return "Palpations"
        case 2: return "Ranges Of Motion"
        case 3: return "Muscle Strength"
        case 4: return "Special Tests"
        default: return "Section \(section)"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.component?.inspection == "" {
                return 0
            }
        }
        if section == 1 {
            if let count = self.palpationsFetchedResultsController?.fetchedObjects?.count {
                return count
            } else {
                return 0
            }
        } else if section == 2 {
            if let count = self.rangesOfMotionFetchedResultsController?.fetchedObjects?.count {
                return count
            } else {
                return 0
            }
        } else if section == 3 {
            if let count = self.musclesFetchedResultsController?.fetchedObjects?.count {
                return count
            } else {
                return 0
            }
        } else if section == 4 {
            if let count = self.specialTestsFetchedResultsController?.fetchedObjects?.count {
                return 1
        } else if section == 5 {
                return 1
            } else {
                return 0
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fixedSectionIndexPath = IndexPath(row: indexPath.row, section: 0)
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        switch (indexPath.section) {
        case 0: cell.textLabel?.text = self.component?.inspection
        case 1:
            if let palpationCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.cell.componentPalpationCell) as? PalpationTableViewCell {
                if let managedPalpation = self.palpationsFetchedResultsController?.object(at: fixedSectionIndexPath) as? PalpationManagedObject {
                    palpationCell.structureLabel.text = managedPalpation.structure
                    palpationCell.detailsLabel.text = (managedPalpation.details == "") ? "No Details" : managedPalpation.details
                    palpationCell.notesLabel.text = (managedPalpation.notes == "") ? "No Notes" : managedPalpation.notes
                }
                return palpationCell
            /*if let managedPalpation = self.palpationsFetchedResultsController?.object(at: fixedSectionIndexPath) as? PalpationManagedObject {
                cell.textLabel?.text = managedPalpation.structure
                //cell.detailTextLabel?.text = managedPalpation.notes*/
            }
        case 2:
            if let rangeOfMotionCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.cell.componentRangeOfMotionCell) as? RangeOfMotionTableViewCell {
                if let managedRangeOfMotion = self.rangesOfMotionFetchedResultsController?.object(at: fixedSectionIndexPath) as? RangeOfMotionManagedObject {
                    rangeOfMotionCell.motionLabel.text = managedRangeOfMotion.motion
                    if (managedRangeOfMotion.degrees == "") {
                        rangeOfMotionCell.degreesLabel.text = managedRangeOfMotion.degrees
                    } else {
                        rangeOfMotionCell.degreesLabel.text = managedRangeOfMotion.degrees + "°"
                    }
                    rangeOfMotionCell.notesLabel.text = (managedRangeOfMotion.notes == "") ? "No Notes" : managedRangeOfMotion.notes
                }
                return rangeOfMotionCell
            }
        case 3:
            if let managedMuscle = self.musclesFetchedResultsController?.object(at: fixedSectionIndexPath) as? MuscleManagedObject {
                cell.textLabel?.text = managedMuscle.name
            }
        case 4:
            if let managedSpecialTest = self.specialTestsFetchedResultsController?.object(at: fixedSectionIndexPath) as? SpecialTestManagedObject {
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = managedSpecialTest.name
            }
        case 5:
            cell.textLabel?.text = "toggle"
            return cell
        default: cell.textLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let fixedSectionIndexPath = IndexPath(row: indexPath.row, section: 0)
            if let managedSpecialTest = self.specialTestsFetchedResultsController?.object(at: fixedSectionIndexPath) as? SpecialTestManagedObject {
                self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toSpecialTestsDetailView, sender: managedSpecialTest)
            }
        }
    }
    
    // MARK: - Fetch Methods
    
    func fetchResultsWithReload(_ shouldReload: Bool) {
        do {
            try self.palpationsFetchedResultsController?.performFetch()
            try self.rangesOfMotionFetchedResultsController?.performFetch()
            try self.musclesFetchedResultsController?.performFetch()
            try self.specialTestsFetchedResultsController?.performFetch()
            if shouldReload {
                self.tableView.reloadData()
            }
        } catch {
            print("Error Fetching Component Details")
            print("\(error)\n")
            let alertController = UIAlertController(title: "Error Reading Data", message: "An error occurred while loading data. Please try again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
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
            if let workingContext = self.palpationsFetchedResultsController?.managedObjectContext {
                workingContext.mergeChanges(fromContextDidSave: saveNotification)
            }
            if let workingContext = self.rangesOfMotionFetchedResultsController?.managedObjectContext {
                workingContext.mergeChanges(fromContextDidSave: saveNotification)
            }
            if let workingContext = self.musclesFetchedResultsController?.managedObjectContext {
                workingContext.mergeChanges(fromContextDidSave: saveNotification)
            }
            if let workingContext = self.specialTestsFetchedResultsController?.managedObjectContext {
                workingContext.mergeChanges(fromContextDidSave: saveNotification)
            }
        }
    }
    
    // MARK: - Refresh Methods
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        if self.component != nil {
            self.remoteConnectionManager!.fetchRangesOfMotion(forComponent: self.component!)
            self.remoteConnectionManager?.fetchMuscles(forComponent: self.component!)
            self.remoteConnectionManager?.fetchSpecialTests(forComponent: self.component!)
        }
    }
    
    // MARK: - Activity Indicator Methods
    
    func initializeActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        self.activityIndicator!.center = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y)
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
        if let managedSpecialTest = sender as? SpecialTestManagedObject {
            if let destination = segue.destination as? SpecialTestDetailTableViewController {
                destination.parentSpecialTest = SpecialTest(managedObject: managedSpecialTest)
            }
        }
    }
    
}

// MARK: - Remote Connection Manager Delegate Methods

extension DetailOverviewViewController : RemoteConnectionManagerDelegate {
    
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
        if self.component != nil {
            if parser.dataType == JSONParser.dataTypes.palpation {
                let palpations = parser.parsePalpations(self.component!)
                datastoreManager.store(palpations)
            } else if parser.dataType == JSONParser.dataTypes.rangeOfMotion {
                let rangesOfMotion = parser.parseRangesOfMotion(self.component!)
                datastoreManager.store(rangesOfMotion)
            } else if parser.dataType == JSONParser.dataTypes.muscle {
                let muscles = parser.parseMuscles(self.component!)
                datastoreManager.store(muscles)
            } else if parser.dataType == JSONParser.dataTypes.specialTest {
                let specialTests = parser.parseSpecialTests(self.component!)
                datastoreManager.store(specialTests)
            } else if parser.dataType == JSONParser.dataTypes.empty {
                datastoreManager.deleteObjectsForEntity(PalpationManagedObject.entityName)
                datastoreManager.deleteObjectsForEntity(RangeOfMotionManagedObject.entityName)
                datastoreManager.deleteObjectsForEntity(MuscleManagedObject.entityName)
                datastoreManager.deleteObjectsForEntity(SpecialTestManagedObject.entityName)
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

extension DetailOverviewViewController : DatastoreManagerDelegate {
    
    func didFinishStoring() {
        Async.main {
            self.fetchResultsWithReload(true)
        }
    }
    
    func didFinishStoringWithError(_ error: NSError) {
        Async.main {
            print("Error Storing Component Details")
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
