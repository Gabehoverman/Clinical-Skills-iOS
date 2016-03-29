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

class ComponentDetailsTableViewController : UITableViewController {
	
	var component: Component?
	
	var rangesOfMotionFetchedResultsController: NSFetchedResultsController?
	
	var remoteConnectionManager: RemoteConnectionManager?
	var datastoreManager: DatastoreManager?
	
	override func viewDidLoad() {
		if (self.component != nil) {
			self.rangesOfMotionFetchedResultsController = RangesOfMotionFetchedResultsControllers.rangesOfMotionFetchedResultsController(forComponent: self.component!)
			self.fetchResultsWithReload(false)
			
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(delegate: self)
			
			if let count = self.rangesOfMotionFetchedResultsController?.fetchedObjects?.count where count == 0 {
				self.remoteConnectionManager?.fetchRangesOfMotion(forComponent: self.component!)
			}
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 5
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
			case 0: return "Inspection"
			case 1: return "Palpation"
			case 2: return "Ranges Of Motion"
			case 3: return "Muscle Strength"
			case 4: return "Special Tests"
			default: return "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
		cell.textLabel?.font = UIFont.systemFontOfSize(16)
		switch (indexPath.section) {
			case 0: cell.textLabel?.text = self.component?.inspection
			case 1: cell.textLabel?.text = "Palpation"
			case 2: cell.textLabel?.text = "Range Of Motion"
			case 3: cell.textLabel?.text = "Muscle Strength"
			case 4: cell.textLabel?.text = "Special Tests"
			default: cell.textLabel?.text = ""
		}
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.rangesOfMotionFetchedResultsController?.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error occured during fetch")
		}
	}
	
}

extension ComponentDetailsTableViewController : RemoteConnectionManagerDelegate {
	
}

extension ComponentDetailsTableViewController : DatastoreManagerDelegate {
	
}