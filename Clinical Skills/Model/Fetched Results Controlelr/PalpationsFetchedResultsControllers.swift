//
//  PalpationsFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 3/31/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PalpationsFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allPalpationsFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: PalpationManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: PalpationManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func palpationsFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: PalpationManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: PalpationManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}