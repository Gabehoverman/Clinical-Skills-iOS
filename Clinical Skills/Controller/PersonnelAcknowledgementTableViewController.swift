//
//  PersonnelAcknowledgementTableViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class PersonnelAcknowledgementTableViewController : UITableViewController {
	
	var personnelAcknowledgements: [PersonnelAcknowledgement]?
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.personnelAcknowledgements != nil {
			return self.personnelAcknowledgements!.count
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
		if self.personnelAcknowledgements != nil {
			if let personnelAcknowledgement = self.personnelAcknowledgements?[indexPath.row] {
				if let cell = self.tableView.dequeueReusableCellWithIdentifier(StoryboardIdentifiers.cell.personnelAcknowledgementCell) as? PersonnelAcknowledgementTableViewCell {
					cell.nameLabel.numberOfLines = 1
					cell.nameLabel.adjustsFontSizeToFitWidth = true
					cell.nameLabel.text = personnelAcknowledgement.name
					cell.roleLabel.numberOfLines = 1
					cell.roleLabel.adjustsFontSizeToFitWidth = true
					cell.roleLabel.text = personnelAcknowledgement.role
					cell.notesLabel.text = personnelAcknowledgement.notes
					return cell
				}
			}
		}
		return UITableViewCell()
	}
	
}