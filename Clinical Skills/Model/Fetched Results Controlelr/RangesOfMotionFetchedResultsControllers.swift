//
//  RangesOfMotionFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick Alexander on 3/26/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RangesOfMotionFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allRangesOfMotionFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: RangeOfMotionManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: RangeOfMotionManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func rangesOfMotionFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: RangeOfMotionManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: RangeOfMotionManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}