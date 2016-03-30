//
//  MusclesFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 3/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MusclesFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allMusclesFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: MuscleManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: MuscleManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func musclesFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: MuscleManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: MuscleManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}