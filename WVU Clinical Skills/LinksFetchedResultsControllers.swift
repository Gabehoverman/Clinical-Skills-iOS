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
	
	class func allLinksFetchedResultsController(managedSystem: SystemManagedObject, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: LinkManagedObject.entityName)
		request.predicate = (NSPredicate(format: "%K CONTAINS[cd] %@", LinkManagedObject.propertyKeys.systems , managedSystem))
		request.sortDescriptors = [NSSortDescriptor(key: LinkManagedObject.propertyKeys.title, ascending: true, selector: Selector("localizedStandardCompare:"))]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleLinksFetchedResultsController(managedSystem: SystemManagedObject, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: LinkManagedObject.entityName)
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "%K = %@", LinkManagedObject.propertyKeys.visible, true))
		predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", LinkManagedObject.propertyKeys.systems, managedSystem))
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: LinkManagedObject.propertyKeys.title, ascending: true, selector: Selector("localizedStandardCompare:"))]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
}
