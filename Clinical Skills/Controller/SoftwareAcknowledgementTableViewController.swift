//
//  SoftwareAcknowledgementTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class SoftwareAcknowledgementTableViewController : UITableViewController {
	
	var softwareAcknowledgements: [SoftwareAcknowledgement]?
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.softwareAcknowledgements != nil {
			return self.softwareAcknowledgements!.count
		}
		return 0
	}
	
	override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if self.softwareAcknowledgements != nil {
			if let softwareAcknowledgement = self.softwareAcknowledgements?[indexPath.row] {
				if let cell = self.tableView.dequeueReusableCellWithIdentifier(StoryboardIdentifiers.cell.softwareAcknowledgementCell) as? SoftwareAcknowledgementTableViewCell {
					cell.nameLabel.numberOfLines = 1
					cell.nameLabel.adjustsFontSizeToFitWidth = true
					cell.nameLabel.text = softwareAcknowledgement.name
					cell.linkLabel.numberOfLines = 1
					cell.linkLabel.adjustsFontSizeToFitWidth = true
					cell.linkLabel.text = softwareAcknowledgement.link
					return cell
				}
			}
		}
		return UITableViewCell()
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let softwareAcknowledgement = self.softwareAcknowledgements?[indexPath.row] {
			self.performSegueWithIdentifier(StoryboardIdentifiers.segue.toSoftwareWebsiteView, sender: softwareAcknowledgement)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == StoryboardIdentifiers.segue.toSoftwareWebsiteView {
			if let destination = segue.destinationViewController as? SoftwareWebsiteViewController {
				if let softwareAcknowledgement = sender as? SoftwareAcknowledgement {
					destination.link = softwareAcknowledgement.link
				}
			}
		}
	}
	
}