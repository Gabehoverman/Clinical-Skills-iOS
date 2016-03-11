//
//  ComponentsFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 3/9/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ComponentsFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allComponentsFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func componentsFetchedResultsController(forSystem: System) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "parent.id", forSystem.id)
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}