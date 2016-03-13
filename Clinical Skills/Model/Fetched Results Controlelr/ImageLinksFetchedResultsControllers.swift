//
//  ImageLinksFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 3/13/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ImageLinksFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allImageLinksFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ImageLinkManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: ImageLinkManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func imageLinksFetchedResultsController(forSpecialTest: SpecialTest) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ImageLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "specialTest.id", forSpecialTest.id)
		request.sortDescriptors = [NSSortDescriptor(key: ImageLinkManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}