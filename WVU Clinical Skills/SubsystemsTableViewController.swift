//
//  SubsystemsTableViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/16/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SubsystemsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var parentSystem: System?
	var fetchedResultsController: NSFetchedResultsController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if (self.parentSystem != nil) {
			self.navigationItem.title = self.parentSystem!.systemName
			self.fetchedResultsController = SubsystemsFetchedResultsControllers.allSubsystemsFetchedResultsController(self.parentSystem!, delegateController: self)
			do {
				try self.fetchedResultsController!.performFetch()
			} catch {
				print("Error fetching subsystems")
			}
		}
    }
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let sections = self.fetchedResultsController?.sections {
			return sections.count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = self.fetchedResultsController?.sections {
			return sections[section].numberOfObjects
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SubsystemCell") as! SystemTableViewCell
		let subsystem = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! System
		cell.systemNameLabel.text = subsystem.systemName
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let controller = self.fetchedResultsController {
			if let subsystem = controller.objectAtIndexPath(indexPath) as? System {
				if (subsystem.subsystems == nil || subsystem.subsystems?.count == 0) {
					performSegueWithIdentifier("toDetailView", sender: subsystem)
				} else {
					performSegueWithIdentifier("toSubsystemView", sender: subsystem)
				}
			} else {
				print("Error getting Subsystem")
			}
		} else {
			print("Error getting controller")
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let subsystem = sender as? System {
			if segue.identifier == "toDetailView" {
				if let destinationVC = segue.destinationViewController as? DetailViewController {
					destinationVC.navigationItem.title = subsystem.systemName
					destinationVC.detailsText = subsystem.systemDescription
				}
			} else if segue.identifier == "toSubsystemView" {
				if let destinationVC = segue.destinationViewController as? SubsystemsTableViewController {
					destinationVC.navigationItem.title = subsystem.systemName
					destinationVC.parentSystem = subsystem
				}
			}
		}
	}

}
