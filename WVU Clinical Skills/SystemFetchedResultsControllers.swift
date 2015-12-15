//
//  SystemFetchedResultsController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/15/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SystemFetchedResultsControllers {
	
	static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allSystemsResultController(delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: "System")
		request.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleSystemsResultController(delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: "System")
		request.predicate = NSPredicate(format: "visible == %@", true)
		request.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
}
