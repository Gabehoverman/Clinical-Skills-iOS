//
//  SystemDetailViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/15/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class SystemDetailViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, SFSafariViewControllerDelegate {
	
	// MARK: - Properties
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var system: System?
	var links: [Link]?
	
	var isExpanded = false
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if self.system != nil {
			self.fetchedResultsController = LinksFetchedResultsControllers.allVisibleLinksFetchedResultsController(self.system!, delegateController: self)
			do {
				try self.fetchedResultsController!.performFetch()
				if let allLinks = self.fetchedResultsController!.fetchedObjects as? [Link] {
					self.links = allLinks
				}
			} catch {
				print("Error fetching links")
			}
		}
	}
	
	// MARK: - Table View Methods
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch(section) {
			case 0: return "Description"
			case 1: return "Video Links"
			default: return "Section \(section)"
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return self.links!.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.Description.rawValue, forIndexPath: indexPath) as! DescriptionTableViewCell
			let propagateTap = UITapGestureRecognizer(target: self, action: Selector("propagateTap:"))
			propagateTap.delegate = self
			cell.descriptionTextView.addGestureRecognizer(propagateTap)
			cell.descriptionTextView.text = self.system!.systemDescription
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardPrototypeCellIdentifiers.Link.rawValue, forIndexPath: indexPath) as! LinkTableViewCell
			cell.linkLabel.text = self.links![indexPath.row].title
			return cell
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			self.isExpanded = !self.isExpanded
			self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		} else {
			if let link = self.links?[indexPath.row] {
				if let url = NSURL(string: link.link) {
					let safariViewController = SFSafariViewController(URL: url)
					self.presentViewController(safariViewController, animated: true, completion: nil)
				}
			}
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			if self.isExpanded {
				return UITableViewAutomaticDimension
			}
			return DescriptionTableViewCell.defaultHeight
		}
		return LinkTableViewCell.defaultHeight
	}
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			if self.isExpanded {
				return UITableViewAutomaticDimension
			}
			return DescriptionTableViewCell.defaultHeight
		}
		return LinkTableViewCell.defaultHeight
	}
	
	// MARK: - Safari View Controller Methods
	
	func safariViewControllerDidFinish(controller: SFSafariViewController) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - Utility Methods
	
	func propagateTap(sender: UIGestureRecognizer) {
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