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

class SystemsTableViewController: UITableViewController {
	
	var allSystems: [System] = []
	
	override func viewWillAppear(animated: Bool) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedOjbectContext = appDelegate.managedObjectContext
		let systemsFetchRequest = NSFetchRequest(entityName: "System")
		let primarySortDescriptor = NSSortDescriptor(key: "systemName", ascending: true)
		systemsFetchRequest.sortDescriptors = [primarySortDescriptor]
		allSystems = (try! managedOjbectContext.executeFetchRequest(systemsFetchRequest)) as! [System]
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.allSystems.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SystemCell") as! SystemTableViewCell
		cell.systemNameLabel.text = self.allSystems[indexPath.row].systemName
		return cell
	}
	
}
