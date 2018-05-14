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
    
	
	//var imageLinksFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
	var videoLinksFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
	
	var remoteConnectionManager: RemoteConnectionManager?
	
	var activityIndicator: UIActivityIndicatorView?
	var presentingAlert: Bool = false
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		
		if self.parentSpecialTest != nil {
			//self.images = [BasicPhoto]()
			
			//self.imageLinksFetchedResultsController = FetchedResultsControllers.imageLinksFetchedResultsController(self.parentSpecialTest!)
			self.videoLinksFetchedResultsController = FetchedResultsControllers.videoLinksFetchedResultsController(self.parentSpecialTest!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
			self.initializeActivityIndicator()
			
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			self.remoteConnectionManager?.fetchVideoLinks(forSpecialTest: self.parentSpecialTest!)
			//self.remoteConnectionManager?.fetchImageLinks(forSpecialTest: self.parentSpecialTest!)
			
			NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundManagedObjectContextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
		}
	}
	
	// MARK: - Table View Controller Methods
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 6
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
			case 0: return "Name"
            case 1: return "How To"
			case 2: return "Positive Sign"
			case 3: return "Indication"
			case 4: return "Notes"
            //case 5: return "Images"
			case 5: return "Video Links"
			default: return  "Section \(section)"
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.parentSpecialTest != nil {
			if section == 0 && self.parentSpecialTest!.name != "" {
				return 1
            } else if section == 1 && self.parentSpecialTest!.howTo != "" {
                return 1
			} else if section == 2 && self.parentSpecialTest!.positiveSign != "" {
				return 1
			} else if section == 3 && self.parentSpecialTest!.indication != "" {
				return 1
			} else if section == 4 && self.parentSpecialTest!.notes != "" {
				return 1
                
            //IMAGE REMOVAL
            /*
			} else if section == 5 {
				if let count = self.imageLinksFetchedResultsController?.fetchedObjects?.count, count != 0 {
					return 1
                }*/
            
			} else if section == 5 {
				if let count = self.videoLinksFetchedResultsController?.fetchedObjects?.count {
					return count
				}
			}
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 5 {
			return UITableViewAutomaticDimension //132
		} else {
			return UITableViewAutomaticDimension
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let fixedSectionIndexPath = IndexPath(row: indexPath.row, section: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .byWordWrapping
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
		cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
		switch (indexPath.section) {
			case 0: cell.textLabel?.text = self.parentSpecialTest?.name
			case 1: cell.textLabel?.text = self.parentSpecialTest?.howTo//positiveSign
            case 2: cell.textLabel?.text = self.parentSpecialTest?.positiveSign
			case 3: cell.textLabel?.text = self.parentSpecialTest?.indication
			case 4: cell.textLabel?.text = self.parentSpecialTest?.notes
            
            //IMAGE REMOVAL
            /*
			case 5: //cell.textLabel?.text = self.imageLinksFetchedResultsController?.fetchedObjects?.description
                    //cell.textLabel?.text = self.imagesCollectionView?.
                if let imagesCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.cell.specialTestImagesCell) as? ImagesTableViewCell {
                    imagesCell.imagesCollectionView.backgroundColor = UIColor.clear
                    imagesCell.imagesCollectionView.dataSource = self as UICollectionViewDataSource
                    imagesCell.imagesCollectionView.delegate = self
                    self.imagesCollectionView = imagesCell.imagesCollectionView
                    return imagesCell
                }*/
			case 5:
				if let managedVideoLink = self.videoLinksFetchedResultsController?.object(at: fixedSectionIndexPath) as? VideoLinkManagedObject {
					cell.accessoryType = .disclosureIndicator
					cell.textLabel?.text = managedVideoLink.title
				}
			default: cell.textLabel?.text = ""
		}
		return cell
	}
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 5 {
			let fixedSectionIndexPath = IndexPath(row: indexPath.row, section: 0) // NSIndexPath referencing section 0 to avoid "no section at index 3" error
			if let managedVideoLink = self.videoLinksFetchedResultsController?.object(at: fixedSectionIndexPath) as? VideoLinkManagedObject {
				self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toVideoView, sender: managedVideoLink)
			}
		}
	}
	
	// MARK: - Fetch Methods
	
	func fetchResultsWithReload(_ shouldReload: Bool) {
		do {
			//try self.imageLinksFetchedResultsController?.performFetch()
			try self.videoLinksFetchedResultsController?.performFetch()
			if shouldReload {
				self.tableView.reloadData()
				//self.imagesCollectionView?.reloadData()
			}
		} catch {
			print("Error Fetching Special Test Details")
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
			
			/*if let workingContext = self.imageLinksFetchedResultsController?.managedObjectContext {
				workingContext.mergeChanges(fromContextDidSave: saveNotification)
			}*/
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(_ refreshControl: UIRefreshControl) {
		self.remoteConnectionManager!.fetchVideoLinks(forSpecialTest: self.parentSpecialTest!)
	}
	
	// MARK: - Activity Indicator Methods
	
	func initializeActivityIndicator() {
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		self.activityIndicator!.center = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y * 1.5)
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
		if segue.identifier == StoryboardIdentifiers.segue.toVideoView {
			if let destination = segue.destination as? VideoViewController {
				if let managedVideoLink = sender as? VideoLinkManagedObject {
					destination.videoLink = VideoLink(managedObject: managedVideoLink)
				}
			}
		}
	}
	
}

extension SpecialTestDetailTableViewController : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let squareSize = 100
		return CGSize(width: squareSize, height: squareSize)
	}
}

// MARK: - Collection View Data Source Methods
/*
extension SpecialTestDetailTableViewController : UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = self.images?.count {
			return count
		} else {
			return 1
		}
	}
	
	private func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let initialImage = self.images?[indexPath.row] {
			//let photosViewController = NYTPhotosViewController(nibName: self.images, bundle: initialImage)
			//self.present(photosViewController, animated: true, completion: nil)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifiers.cell.collectionImageCell, for: indexPath) as? ImageCollectionViewCell {
			if let photo = self.images?[indexPath.row] {
				cell.imageView.image = photo.image
			}
			return cell
		}
		return UICollectionViewCell()
	}
}*/




// MARK: - Collection View Delegate Methods

extension SpecialTestDetailTableViewController : UICollectionViewDelegate {
	
}

// MARK: - Remote Connection Manager Delegate Methods

extension SpecialTestDetailTableViewController : RemoteConnectionManagerDelegate {
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
		/*if parser.dataType == JSONParser.dataTypes.imageLink {
			if self.parentSpecialTest != nil {
				let imageLinks = parser.parseImageLinks(self.parentSpecialTest!)
				datastoreManager.store(imageLinks)
				for imageLink in imageLinks {
					self.remoteConnectionManager?.fetchImageData(forCloudinaryLink: imageLink.link)
				}
			}
		} else */
        if parser.dataType == JSONParser.dataTypes.videoLink {
			if self.parentSpecialTest != nil {
				let videoLinks = parser.parseVideoLinks(self.parentSpecialTest!)
				datastoreManager.store(videoLinks)
				/* if let count = self.imageLinksFetchedResultsController?.fetchedObjects?.count, count == 0 {
					self.remoteConnectionManager?.fetchImageLinks(forSpecialTest: self.parentSpecialTest!)
				}*/
			}
		}
	}
	
	func didFinishCloudinaryImageRequestWithData(_ receivedData: Data) {
		if let image = UIImage(data: receivedData) {
			let photo = BasicPhoto(image: image, imageData: receivedData, captionTitle: NSAttributedString(string: ""))
			self.images!.append(photo)
		}
		Async.main {
			self.fetchResultsWithReload(true)
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

extension SpecialTestDetailTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
	func didFinishStoringWithError(_ error: NSError) {
		Async.main {
			print("Error Storing Special Test Details")
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
