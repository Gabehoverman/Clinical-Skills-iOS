//
//  ComponentDetailsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick Alexander on 3/25/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import BRYXBanner
import Async

class ComponentDetailsTableViewController : UITableViewController {
	
	var component: Component?
	
	var palpationsFetchedResultsController: NSFetchedResultsController?
	var rangesOfMotionFetchedResultsController: NSFetchedResultsController?
	var musclesFetchedResultsController: NSFetchedResultsController?
	var specialTestsFetchedResultsController: NSFetchedResultsController?
	
	var remoteConnectionManager: RemoteConnectionManager?
	var datastoreManager: DatastoreManager?
	
	var activityIndicator: UIActivityIndicatorView?
	
	override func viewDidLoad() {
		if (self.component != nil) {
			self.palpationsFetchedResultsController = PalpationsFetchedResultsControllers.palpationsFetchedResultsController(forComponent: self.component!)
			self.rangesOfMotionFetchedResultsController = RangesOfMotionFetchedResultsControllers.rangesOfMotionFetchedResultsController(forComponent: self.component!)
			self.musclesFetchedResultsController = MusclesFetchedResultsControllers.musclesFetchedResultsController(forComponent: self.component!)
			self.specialTestsFetchedResultsController = SpecialTestsFetchedResultsControllers.specialTestsFetchedResultsController(self.component!)
			self.fetchResultsWithReload(false)
			
			self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), forControlEvents: .ValueChanged)
			
			self.initializeActivityIndicator()
			
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			if let count = self.palpationsFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchPalpations(forComponent: self.component!)
			}
			
			if let count = self.rangesOfMotionFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchRangesOfMotion(forComponent: self.component!)
			}
			
			if let count = self.musclesFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchMuscles(forComponent: self.component!)
			}
			
			if let count = self.specialTestsFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchSpecialTests(forComponent: self.component!)
			}
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 5
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
			case 0: return "Inspection"
			case 1: return "Palpations"
			case 2: return "Ranges Of Motion"
			case 3: return "Muscle Strength"
			case 4: return "Special Tests"
			default: return "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
				return count
			} else {
				0
			}
		}
		return 1
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
		switch (indexPath.section) {
			case 0: cell.textLabel?.text = self.component?.inspection
			case 1:
				if let palpationCell = tableView.dequeueReusableCellWithIdentifier("PalpationCell") as? PalpationTableViewCell {
					if let managedPalpation = self.palpationsFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? PalpationManagedObject {
						palpationCell.structureLabel.text = managedPalpation.structure
						palpationCell.detailsLabel.text = managedPalpation.details
						palpationCell.notesLabel.text = managedPalpation.notes
					}
					return palpationCell
				}
			case 2:
				if let rangeOfMotionCell = tableView.dequeueReusableCellWithIdentifier("RangeOfMotionCell") as? RangeOfMotionTableViewCell {
					if let managedRangeOfMotion = self.rangesOfMotionFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? RangeOfMotionManagedObject {
						rangeOfMotionCell.motionLabel.text = managedRangeOfMotion.motion
						rangeOfMotionCell.degreesLabel.text = managedRangeOfMotion.degrees + "°"
						rangeOfMotionCell.notesLabel.text = managedRangeOfMotion.notes
					}
					return rangeOfMotionCell
				}
			case 3:
				if let managedMuscle = self.musclesFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? MuscleManagedObject {
					cell.textLabel?.text = managedMuscle.name
				}
			case 4:
				if let managedSpecialTest = self.specialTestsFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? SpecialTestManagedObject {
					cell.accessoryType = .DisclosureIndicator
					cell.textLabel?.text = managedSpecialTest.name
				}
			default: cell.textLabel?.text = ""
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 4 {
			let fixedSectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
			if let managedSpecialTest = self.specialTestsFetchedResultsController?.objectAtIndexPath(fixedSectionIndexPath) as? SpecialTestManagedObject {
				self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toSpecialTestsDetailView, sender: managedSpecialTest)
			}
		}
	}
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.palpationsFetchedResultsController?.performFetch()
			try self.rangesOfMotionFetchedResultsController?.performFetch()
			try self.musclesFetchedResultsController?.performFetch()
			try self.specialTestsFetchedResultsController?.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error occured during fetch")
		}
	}
	
	// MARK: - Refresh Methods
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		if self.component != nil {
			self.remoteConnectionManager!.fetchRangesOfMotion(forComponent: self.component!)
			self.remoteConnectionManager?.fetchMuscles(forComponent: self.component!)
			self.remoteConnectionManager?.fetchSpecialTests(forComponent: self.component!)
		}
	}
	
	func initializeActivityIndicator() {
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		self.activityIndicator!.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		self.activityIndicator!.center = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y)
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
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let managedSpecialTest = sender as? SpecialTestManagedObject {
			if let destination = segue.destinationViewController as? SpecialTestDetailTableViewController {
				destination.parentSpecialTest = SpecialTest.specialTestFromManagedObject(managedSpecialTest)
			}
		}
	}
	
}

extension ComponentDetailsTableViewController : RemoteConnectionManagerDelegate {
	
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
		if self.component != nil {
			if parser.dataType == JSONParser.dataTypes.palpation {
				let palpations = parser.parsePalpations(self.component!)
				self.datastoreManager?.storePalpations(palpations)
			} else if parser.dataType == JSONParser.dataTypes.rangeOfMotion {
				let rangesOfMotion = parser.parseRangesOfMotion(self.component!)
				self.datastoreManager?.storeRangesOfMotion(rangesOfMotion)
			} else if parser.dataType == JSONParser.dataTypes.muscle {
				let muscles = parser.parseMuscles(self.component!)
				self.datastoreManager?.storeMuscles(muscles)
			} else if parser.dataType == JSONParser.dataTypes.specialTest {
				let specialTests = parser.parseSpecialTests(self.component!)
				self.datastoreManager?.storeSpecialTests(specialTests)
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
			self.showNetworkStatusBanner()
		}
	}
	
	func showNetworkStatusBanner() {
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

extension ComponentDetailsTableViewController : DatastoreManagerDelegate {
	
	func didFinishStoring() {
		Async.main {
			self.fetchResultsWithReload(true)
		}
	}
	
}