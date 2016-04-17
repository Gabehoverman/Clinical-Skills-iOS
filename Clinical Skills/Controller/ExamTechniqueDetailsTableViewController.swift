//
//  ExamTechniqueDetailsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Async

class ExamTechniqueDetailsTableViewController : UITableViewController {
	
	// MARK: - Properites
	
	var examTechnique: ExamTechnique?
	
	var videoLinksFetchedResultsController: NSFetchedResultsController?
	
	var remoteConnectionManager: RemoteConnectionManager?
	
	var activityIndicator: UIActivityIndicatorView?
	var presentingAlert: Bool = false
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if self.examTechnique != nil {
			self.videoLinksFetchedResultsController = FetchedResultsControllers.videoLinksFetchedResultsController(self.examTechnique!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
			self.initializeActivityIndicator()
			
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchVideoLinks(forExamTechnique: self.examTechnique!)
			}
			
			NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
		}
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
			case 0: return "Name"
			case 1: return "Details"
			case 2: return "Video Links"
			default: return "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.examTechnique != nil {
			if section == 0 && self.examTechnique!.name != "" {
				return 1
			} else if section == 1 && self.examTechnique!.details != "" {
				return 1
			} else if section == 2 {
				if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count where count != 0 {
					return count
				}
			}
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
		let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.systemFontOfSize(15)
		switch indexPath.section {
			case 0: cell.textLabel?.text = self.examTechnique!.name
			case 1: cell.textLabel?.text = self.examTechnique!.details
			case 2:
				if let managedVideoLink = self.videoLinksFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? VideoLinkManagedObject {
					cell.accessoryType = .DisclosureIndicator
					cell.textLabel?.text = managedVideoLink.title
			}
			default: cell.textLabel?.text = ""
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 2 {
			let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
			if let managedVideoLink = self.videoLinksFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? VideoLinkManagedObject {
				self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toVideoView, sender: managedVideoLink)
			}
		}
	}
	
	// MARK: - Fetch Methods
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.videoLinksFetchedResultsController?.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error Fetching Exam Technique Details")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
				self.presentingAlert = true
				self.presentViewController(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
	
	// MARK: - Core Data Notification Methods
	
	func backgroundManagedObjectContextDidSave(saveNotification: NSNotification) {
		Async.main {
			if let workingContext = self.videoLinksFetchedResultsController?.managedObjectContext {
				workingContext.mergeChangesFromContextDidSaveNotification(saveNotification)
			}
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchVideoLinks(forExamTechnique: self.examTechnique!)
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
	
	// MARK: - Navigation Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryboardIdentifiers.segue.toVideoView {
			if let destination = segue.destinationViewController as? VideoViewController {
				if let managedVideoLink = sender as? VideoLinkManagedObject {
					destination.videoLink = VideoLink(managedObject: managedVideoLink)
				}
			}
		}
	}
	
}

// MARK: - Remote Connection Manager Delegate Methods

extension ExamTechniqueDetailsTableViewController : RemoteConnectionManagerDelegate {
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
		if parser.dataType == JSONParser.dataTypes.videoLink {
			if self.examTechnique != nil {
				let videoLinks = parser.parseVideoLinks(self.examTechnique!)
				datastoreManager.storeVideoLinks(videoLinks)
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

// MARK: - Datastore Manager Delegate Methods

extension ExamTechniqueDetailsTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
	func didFinishStoringWithError(error: NSError) {
		Async.main {
			print("Error Storing Exam Technique Details")
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