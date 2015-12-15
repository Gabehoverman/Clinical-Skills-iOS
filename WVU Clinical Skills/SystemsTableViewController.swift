//
//  SystemsTableViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
	Table View displaying all System data inside the database
*/
class SystemsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var fetchedResultsController: NSFetchedResultsController?
	
	override func viewDidLoad() {
		self.fetchedResultsController = SystemFetchedResultsControllers.allVisibleSystemsResultController(self)
		do {
			try self.fetchedResultsController!.performFetch()
		} catch {
			print("Error occurred during System fetch")
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = self.fetchedResultsController!.sections {
			return sections.count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = self.fetchedResultsController!.sections {
			return sections[section].numberOfObjects
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SystemCell") as! SystemTableViewCell
		let system = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! System
		cell.systemNameLabel.text = system.systemName
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let system = controller.objectAtIndexPath(indexPath) as? System {
				performSegueWithIdentifier("toDetailView", sender: system)
			} else {
				print("Error getting System")
			}
		} else {
			print("Error getting controller")
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let system = sender as? System {
			if (segue.identifier == "toDetailView") {
				if let destination = segue.destinationViewController as? DetailViewController {
					destination.navigationItem.title = system.systemName
					destination.detailsText = system.systemDescription
				}
			} else if (segue.identifier == "toSubcategoryView") {
				print("To Subcategory View")
			}
		}
	}
	
}
