//
//  LinksFetchedResultsControllers.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/17/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class LinksFetchedResultsControllers {
	
	static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allLinksFetchedResultsController(system: System, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: "Link")
		request.predicate = NSPredicate(format: "%K = %@", "system.systemName", system.systemName)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: Selector("localizedStandardCompare:"))]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
}
