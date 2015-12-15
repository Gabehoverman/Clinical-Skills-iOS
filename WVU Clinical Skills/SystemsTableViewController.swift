//
//  SystemsTableViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

class SystemsTableViewController: UITableViewController {

	let data = [
		"Musculoskeletal",
		"Cardiovascular",
		"Ear, Nose, Throat"
	]
	
	
	override func viewDidLoad() {
		
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SystemCell") as! SystemTableViewCell
		cell.systemNameLabel.text = self.data[indexPath.row]
		return cell
	}
	
}
