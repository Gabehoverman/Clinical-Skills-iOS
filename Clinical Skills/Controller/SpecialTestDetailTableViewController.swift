//
//  SpecialTestDetailTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import NYTPhotoViewer
import Async

class SpecialTestDetailTableViewController : UITableViewController {
	
	// MARK: - Properites
	
	var parentSpecialTest: SpecialTest?
	var images: [BasicPhoto]?
	
	weak var imagesCollectionView: UICollectionView?
	
	var imageLinksFetchedResultsController: NSFetchedResultsController?
	var videoLinksFetchedResultsController: NSFetchedResultsController?
	
	var datastoreManager: DatastoreManager?
	var remoteConnectionManager: RemoteConnectionManager?
	
	var activityIndicator: UIActivityIndicatorView?
	var presentingAlert: Bool = false
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		
		if self.parentSpecialTest != nil {
			self.images = [BasicPhoto]()
			
			self.imageLinksFetchedResultsController = ImageLinksFetchedResultsControllers.imageLinksFetchedResultsController(self.parentSpecialTest!)
			self.videoLinksFetchedResultsController = VideoLinksFetchedResultsControllers.videoLinksFetchedResultsController(self.parentSpecialTest!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
			self.initializeActivityIndicator()
			
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
		
			if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchVideoLinks(forSpecialTest: self.parentSpecialTest!)
			}
			
			if let count = self.imageLinksFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchImageLinks(forSpecialTest: self.parentSpecialTest!)
			} else {
				for managedImageLink in (self.imageLinksFetchedResultsController?.fetchedObjects as! [ImageLinkManagedObject]) {
					self.remoteConnectionManager?.fetchImageData(forCloudinaryLink: managedImageLink.link)
				}
			}
		}
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 6
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
			case 0: return "Name"
			case 1: return "Positive Sign"
			case 2: return "Indication"
			case 3: return "Notes"
			case 4: return "Images"
			case 5: return "Video Links"
			default: return  "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.parentSpecialTest != nil {
			if section == 0 && self.parentSpecialTest!.name != "" {
				return 1
			} else if section == 1 && self.parentSpecialTest!.positiveSign != "" {
				return 1
			} else if section == 2 && self.parentSpecialTest!.indication != "" {
				return 1
			} else if section == 3 && self.parentSpecialTest!.notes != "" {
				return 1
			} else if section == 4 {
				if let count = self.imageLinksFetchedResultsController?.fetchedObjects?.count where count != 0 {
					return 1
				}
			} else if section == 5 {
				if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count {
					return count
				}
			}
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 4 {
			return 132
		} else {
			return UITableViewAutomaticDimension
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.systemFontOfSize(15)
		switch (indexPath.section) {
			case 0: cell.textLabel?.text = self.parentSpecialTest?.name
			case 1: cell.textLabel?.text = self.parentSpecialTest?.positiveSign
			case 2: cell.textLabel?.text = self.parentSpecialTest?.indication
			case 3: cell.textLabel?.text = self.parentSpecialTest?.notes
			case 4:
				if let imagesCell = tableView.dequeueReusableCellWithIdentifier(StoryboardIdentifiers.cell.specialTestImagesCell) as? ImagesTableViewCell {
					imagesCell.imagesCollectionView.backgroundColor = UIColor.clearColor()
					imagesCell.imagesCollectionView.dataSource = self
					imagesCell.imagesCollectionView.delegate = self
					self.imagesCollectionView = imagesCell.imagesCollectionView
					return imagesCell
				}
			case 5:
				if let managedVideoLink = self.videoLinksFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? VideoLinkManagedObject {
					cell.accessoryType = .DisclosureIndicator
					cell.textLabel?.text = managedVideoLink.title
				}
			default: cell.textLabel?.text = ""
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 5 {
			let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
			if let managedVideoLink = self.videoLinksFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? VideoLinkManagedObject {
				self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toVideoView, sender: managedVideoLink)
			}
		}
	}
	
	// MARK: - Fetch Methods
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.imageLinksFetchedResultsController?.performFetch()
			try self.videoLinksFetchedResultsController?.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error Fetching Special Test Details")
			print("\(error)\n")
			if !self.presentingAlert && self.presentedViewController == nil {
				let alertController = UIAlertController(title: "Error Storing Data", message: "An error occurred while storing data. Please try agian.", preferredStyle: .Alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
				self.presentingAlert = true
				self.presentViewController(alertController, animated: true, completion: { self.presentingAlert = false })
			}
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchVideoLinks(forSpecialTest: self.parentSpecialTest!)
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

extension SpecialTestDetailTableViewController : UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let squareSize = 100
		return CGSize(width: squareSize, height: squareSize)
	}
}

// MARK: - Collection View Data Source Methods

extension SpecialTestDetailTableViewController : UICollectionViewDataSource {
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = self.images?.count {
			return count
		} else {
			return 0
		}
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let initialImage = self.images?[indexPath.row] {
			let photosViewController = NYTPhotosViewController(photos: self.images, initialPhoto: initialImage)
			self.presentViewController(photosViewController, animated: true, completion: nil)
		}
	}
	
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryboardIdentifiers.cell.collectionImageCell, forIndexPath: indexPath) as? ImageCollectionViewCell {
			if let photo = self.images?[indexPath.row] {
				cell.imageView.image = photo.image
			}
			return cell
		}
		return UICollectionViewCell()
	}
}

// MARK: - Collection View Delegate Methods

extension SpecialTestDetailTableViewController : UICollectionViewDelegate {
	
}

// MARK: - Remote Connection Manager Delegate Methods

extension SpecialTestDetailTableViewController : RemoteConnectionManagerDelegate {
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
		if parser.dataType == JSONParser.dataTypes.imageLink {
			if self.parentSpecialTest != nil {
				let imageLinks = parser.parseImageLinks(self.parentSpecialTest!)
				self.datastoreManager?.storeImageLinks(imageLinks)
				for imageLink in imageLinks {
					self.remoteConnectionManager?.fetchImageData(forCloudinaryLink: imageLink.link)
				}
			}
		} else if parser.dataType == JSONParser.dataTypes.videoLink {
			if self.parentSpecialTest != nil {
				let videoLinks = parser.parseVideoLinks(self.parentSpecialTest!)
				self.datastoreManager?.storeVideoLinks(videoLinks)
				if let count = self.imageLinksFetchedResultsController?.fetchedObjects?.count where count == 0 {
					self.remoteConnectionManager?.fetchImageLinks(forSpecialTest: self.parentSpecialTest!)
				}
			}
		}
	}
	
	func didFinishCloudinaryImageRequestWithData(receivedData: NSData) {
		if let image = UIImage(data: receivedData) {
			let photo = BasicPhoto(image: image, imageData: receivedData, captionTitle: NSAttributedString(string: ""))
			self.images!.append(photo)
		}
		Async.main {
			self.imagesCollectionView?.reloadData()
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

extension SpecialTestDetailTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
	func didFinishStoringWithError(error: NSError) {
		Async.main {
			print("Error Storing Special Test Details")
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