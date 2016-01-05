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
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Parent.rawValue, managedParentSystem)
		request.sortDescriptors = [NSSortDescriptor(key: ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleSubsystemsFetchedResultsController(managedParentSystem: SystemManagedObject, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Visible.rawValue, true))
		predicates.append(NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Parent.rawValue, managedParentSystem))
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
}
