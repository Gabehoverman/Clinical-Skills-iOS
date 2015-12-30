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
	
	class func allSubsystemsFetchedResultsController(parentSystem: System, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Parent.rawValue, parentSystem)
		request.sortDescriptors = [NSSortDescriptor(key: ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleSubsystemsFetchedResultsController(parentSystem: System, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Visible.rawValue, true))
		predicates.append(NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Parent.rawValue, parentSystem))
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
}
