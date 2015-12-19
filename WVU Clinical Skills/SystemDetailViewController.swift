//
//  SystemDetailViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/15/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SystemDetailViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {

	var fetchedResultsController: NSFetchedResultsController?
	
	var system: System?
	var links: [Link]?
	
	var didExpandDescriptionCell = false
	
	override func viewDidLoad() {
		if self.system != nil {
			self.fetchedResultsController = LinksFetchedResultsControllers.allVisibleLinksFetchedResultsController(self.system!, delegateController: self)
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
			if self.didExpandDescriptionCell {
				if let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.descriptionCell) as? SystemDetailDescriptionTableViewCell {
					return cell.descriptionTextView.sizeThatFits(CGSize(width: cell.descriptionTextView.bounds.size.width, height: CGFloat.max)).height
				}
			}
			return SystemDetailDescriptionTableViewCell.defaultHeight
		}
		return tableView.rowHeight
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.descriptionCell) as! SystemDetailDescriptionTableViewCell
			let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("descriptionTextViewTapped:"))
			gestureRecognizer.delegate = self
			cell.descriptionTextView.addGestureRecognizer(gestureRecognizer)
			//cell.descriptionTextView.text = self.system?.systemDescription
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.linkCell) as! SystemDetailLinkTableViewCell
			cell.linkLabel.text = self.links![indexPath.row].title
			return cell
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			self.didExpandDescriptionCell = !self.didExpandDescriptionCell
			tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		} else {
			if let link = self.links?[indexPath.row] {
				self.performSegueWithIdentifier(StoryboardSegueIdentifiers.toVideoView, sender: link)
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let link = sender as? Link {
			if segue.identifier == StoryboardSegueIdentifiers.toVideoView {
				if let destinationNavVC = segue.destinationViewController as? UINavigationController {
					if let destinationVC = destinationNavVC.viewControllers.first as? VideoViewController {
						destinationVC.videoLink = link.link
					}
				}
			}
		}
	}
	
	func descriptionTextViewTapped(sender: AnyObject) {
		if let textView = sender.view as? UITextView {
			if var cellToSelect = textView.superview {
				while !cellToSelect.isKindOfClass(UITableViewCell) {
					cellToSelect = cellToSelect.superview!
				}
				if let cell = cellToSelect as? UITableViewCell {
					self.tableView(self.tableView, didSelectRowAtIndexPath: self.tableView.indexPathForCell(cell)!)
				}
			}
		}
	}
}