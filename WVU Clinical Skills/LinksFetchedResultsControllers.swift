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
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
//		request.predicate = NSPredicate(format: "%K = %@", "system.systemName", system.systemName)
		request.predicate = (NSPredicate(format: "%K CONTAINS %@", "systems", system))
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: Selector("localizedStandardCompare:"))]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
	
	class func allVisibleLinksFetchedResultsController(system: System, delegateController: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "%K = %@", "visible", true))
//		predicates.append(NSPredicate(format: "%K = %@", "system.systemName", system.systemName))
		predicates.append(NSPredicate(format: "%K CONTAINS %@", "systems", system))
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: Selector("localizedStandardCompare:"))]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = delegateController
		return controller
	}
}
