//
//  ComponentDetailsTableViewController.swift
//  Clinical Skills
//
//  Created by Nick Alexander on 3/25/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import BRYXBanner

class ComponentDetailsTableViewController : UITableViewController {
	
	var component: Component?
	
	var rangesOfMotionFetchedResultsController: NSFetchedResultsController?
	
	override func viewDidLoad() {
		print(self.component?.name)
	}
	
}