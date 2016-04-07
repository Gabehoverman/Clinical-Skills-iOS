//
//  VideoLinksFetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VideoLinksFetchedResultsControllers {
	
	static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func allVideoLinksFetchedResultsController() -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func videoLinksFetchedResultsController(forExamTechnique: ExamTechnique) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "examTechnique.id", forExamTechnique.id)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
	class func videoLinksFetchedResultsController(forSpecialTest: SpecialTest) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "specialTest.id", forSpecialTest.id)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.id, ascending: true)]
		let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return controller
	}
	
}