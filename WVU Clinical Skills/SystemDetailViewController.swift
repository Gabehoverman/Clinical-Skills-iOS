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
		self.tableView.tableFooterView = UIView(frame: CGRectZero)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch (section) {
			case 0: return "Description"
			case 1: return "Video Links"
			default: return "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0) {
			return 1
		} else {
			return self.links!.count
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 132
		} else {
			return 44
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell") as! SystemDetailDescriptionTableViewCell
			cell.descriptionTextView.text = self.system?.systemDescription
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("LinkCell") as! SystemDetailLinkTableViewCell
			cell.linkLabel.text = self.links![indexPath.row].title
			return cell
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section != 0 {
			if let link = self.links?[indexPath.row] {
				self.performSegueWithIdentifier("toVideoView", sender: link)
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let link = sender as? Link {
			if segue.identifier == "toVideoView" {
				if let destinationNavVC = segue.destinationViewController as? UINavigationController {
					if let destinationVC = destinationNavVC.viewControllers.first as? VideoViewController {
						destinationVC.videoLink = link.link
					}
				}
			}
		}
	}
}