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

class SystemDetailViewController: UITableViewController {
	
	// MARK: - Class Constants
	
	static let storyboardIdentifier = "SystemDetailViewController"
	
	// MARK: - Properties
	
	var fetchedResultsController: NSFetchedResultsController?
	
	var managedSystem: SystemManagedObject?
	
	var isExpanded = false
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if self.managedSystem != nil {
			
		}
	}
	
	// MARK: - Table View Controller Methods
	
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
		return 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier(DescriptionTableViewCell.descriptionCellIdentifier, forIndexPath: indexPath) as! DescriptionTableViewCell
			let propagateTap = UITapGestureRecognizer(target: self, action: Selector("propagateTap:"))
			propagateTap.delegate = self
			cell.descriptionTextView.addGestureRecognizer(propagateTap)
			cell.descriptionTextView.text = self.managedSystem!.details
			return cell
		} else {
//			let cell = tableView.dequeueReusableCellWithIdentifier(LinkTableViewCell.linkCellIdentifier, forIndexPath: indexPath) as! LinkTableViewCell
			return UITableViewCell()
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			self.isExpanded = !self.isExpanded
			self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			if self.isExpanded {
				return UITableViewAutomaticDimension
			}
			return DescriptionTableViewCell.defaultHeight
		}
		return 0
//		return LinkTableViewCell.defaultHeight
	}
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			if self.isExpanded {
				return UITableViewAutomaticDimension
			}
			return DescriptionTableViewCell.defaultHeight
		}
		return 0
//		return LinkTableViewCell.defaultHeight
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

// MARK: - Fetched Results Controller Delegate Methods

extension SystemDetailViewController: NSFetchedResultsControllerDelegate {
	// No Methods Required Currently
}

// MARK: - Gesture Recognizer Delegate Methods

extension SystemDetailViewController: UIGestureRecognizerDelegate {
	// No Methods Required Currently
}

// MARK: - Safari View Controller Delegate Methods

extension SystemDetailViewController: SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(controller: SFSafariViewController) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}