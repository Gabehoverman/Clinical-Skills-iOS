//
//  SystemDetailViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/15/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SystemDetailViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var fetchedResultsController: NSFetchedResultsController?
	
	var system: System?
	var links: [Link]?
	
	override func viewDidLoad() {
		self.tableView.tableFooterView = UIView(frame: CGRectZero)
		if self.system != nil {
			self.fetchedResultsController = LinksFetchedResultsControllers.allLinksFetchedResultsController(self.system!, delegateController: self)
			do {
				try self.fetchedResultsController!.performFetch()
				if let allLinks = self.fetchedResultsController!.fetchedObjects as? [Link] {
					self.links = allLinks
				}
			} catch {
				print("Error fetching Links")
			}
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.links != nil {
			return self.links!.count + 1
		}
		return 1
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 132
		} else {
			return 44
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell") as! SystemDetailDescriptionTableViewCell
			cell.descriptionTextView.text = self.system?.systemDescription
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("LinkCell") as! SystemDetailLinkTableViewCell
			cell.linkLabel.text = self.links![indexPath.row - 1].title
			return cell
		}
	}

}