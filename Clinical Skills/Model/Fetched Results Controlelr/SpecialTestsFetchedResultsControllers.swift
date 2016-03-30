//
//  SpecialTestsFetchedResultsController.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SpecialTestsFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allSpecialTestsFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: SpecialTestManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func specialTestsFetchedResultsController(forComponent: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", forComponent.id)
		request.sortDescriptors = [NSSortDescriptor(key: SpecialTestManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}