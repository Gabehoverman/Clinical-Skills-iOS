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
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = nil", ManagedObjectEntityPropertyKeys.System.Parent.rawValue)
		request.sortDescriptors = [NSSortDescriptor(key: ManagedObjectEntityPropertyKeys.System.Name.rawValue, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleSystemsResultController(delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "%K = nil", ManagedObjectEntityPropertyKeys.System.Parent.rawValue))
		predicates.append(NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.System.Visible.rawValue, true))
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: ManagedObjectEntityPropertyKeys.System.Name.rawValue, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
}
