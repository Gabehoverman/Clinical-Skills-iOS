//
//  ExamTechniquesFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ExamTechniquesFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allExamTechniquesFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ExamTechniqueManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: ExamTechniqueManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func examTechniquesFetchedResultsController(forSystem: System) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ExamTechniqueManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "system.id", forSystem.id)
		request.sortDescriptors = [NSSortDescriptor(key: ExamTechniqueManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}