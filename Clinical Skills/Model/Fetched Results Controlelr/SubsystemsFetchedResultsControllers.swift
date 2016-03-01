//
//  SubsystemsFetchedResultsControllers.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/16/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class SubsystemsFetchedResultsControllers {

	static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allSubsystemsFetchedResultsController(managedParentSystem: SystemManagedObject, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %@", SystemManagedObject.propertyKeys.parent, managedParentSystem)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.name, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleSubsystemsFetchedResultsController(managedParentSystem: SystemManagedObject, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "%K = %@", SystemManagedObject.propertyKeys.visible, true))
		predicates.append(NSPredicate(format: "%K = %@", SystemManagedObject.propertyKeys.parent, managedParentSystem))
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.name, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
}
