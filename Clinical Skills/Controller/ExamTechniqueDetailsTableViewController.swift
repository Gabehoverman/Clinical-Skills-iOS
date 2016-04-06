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
import BRYXBanner
import Async

class ExamTechniqueDetailsTableViewController : UITableViewController {
	
	// MARK: - Properites
	
	var examTechnique: ExamTechnique?
	
	var videoLinksFetchedResultsController: NSFetchedResultsController?
	
	var datastoreManager: DatastoreManager?
	var remoteConnectionManager: RemoteConnectionManager?
	
	var activityIndicator: UIActivityIndicatorView?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if self.examTechnique != nil {
			self.videoLinksFetchedResultsController = VideoLinksFetchedResultsControllers.videoLinksFetchedResultsController(self.examTechnique!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
			self.initializeActivityIndicator()
			
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchVideoLinks(forExamTechnique: self.examTechnique!)
			}
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
		cell.textLabel?.font = UIFont.systemFontOfSize(14)
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
//				if let url = NSURL(string: managedVideoLink.link) {
//					let safariViewController = SFSafariViewController(URL: url)
//					safariViewController.delegate = self
//					self.presentViewController(safariViewController, animated: true, completion: nil)
//				}
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
			print("Error occurred during fetch")
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
					destination.videoLink = VideoLink.videoLinkFromManagedObject(managedVideoLink)
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
		let parser = JSONParser(rawData: receivedData)
		if parser.dataType == JSONParser.dataTypes.videoLink {
			if self.examTechnique != nil {
				let videoLinks = parser.parseVideoLinks(self.examTechnique!)
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

extension ExamTechniqueDetailsTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
}