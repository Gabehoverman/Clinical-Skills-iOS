//
//  ComponentsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/9/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import BRYXBanner
import CoreData

class ComponentsTableViewController : UITableViewController {
	
	var parentSystem: System?
	var fetchedResultsController: NSFetchedResultsController?
	var datastoreManager: DatastoreManager?
	var remoteConnectionManager: RemoteConnectionManager?
	
	override func viewWillAppear(animated: Bool) {
		if self.parentSystem != nil {
			self.fetchedResultsController = ComponentsFetchedResultsControllers.componentsFetchedResultsController(self.parentSystem!, delegateController: self)
			self.datastoreManager = DatastoreManager(delegate: self)
			self.remoteConnectionManager = RemoteConnectionManager(shouldRequestFromLocal: UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost), delegate: self)
			self.remoteConnectionManager!.fetchComponents(self.parentSystem!)
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = self.fetchedResultsController?.fetchedObjects?.count {
			return count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ComponentTableViewCell") as! ComponentTableViewCell
		if let managedComponent = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? ComponentManagedObject {
			cell.componentNameLabel.text = managedComponent.name
		} else {
			cell.componentNameLabel.text = "Error Fetching Component Name"
		}
		return cell
	}
	
	func fetchResultsWithReload(shouldReload: Bool) {
		do {
			try self.fetchedResultsController!.performFetch()
			if shouldReload {
				self.tableView.reloadData()
			}
		} catch {
			print("Error occurred during System fetch")
		}
	}
	
	func showBanner() {
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

extension ComponentsTableViewController : NSFetchedResultsControllerDelegate {
	
}

extension ComponentsTableViewController : DatastoreManagerDelegate {
	func didFinishStoring() {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.fetchResultsWithReload(true)
		}
	}
}

extension ComponentsTableViewController : RemoteConnectionManagerDelegate {
	
	func didFinishDataRequestWithData(receivedData: NSData) {
		let parser = JSONParser(jsonData: receivedData)
		if parser.dataType == JSONParser.dataTypes.system {
			self.datastoreManager!.storeSystems(parser.parseSystems())
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.showBanner()
			})
		} else if parser.dataType == JSONParser.dataTypes.component {
			if self.parentSystem != nil {
				self.datastoreManager!.storeComponents(parser.parseComponents(self.parentSystem!))
				self.datastoreManager!.printComponents()
			}
		}
	}
	
}