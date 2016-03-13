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
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allSystemsResultController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}
