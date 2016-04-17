//
//  FetchedResultsControllers.swift
//  Clinical Skills
//
//  Created by Nick on 4/17/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchedResultsControllers {
	
	static let managedObjectContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	class func fetchedResultsControllerForRequest(request: NSFetchRequest) -> NSFetchedResultsController {
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
	}
	
	static var allSystemsResultController: NSFetchedResultsController {
		get {
			let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
			request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.id, ascending: true)]
			return fetchedResultsControllerForRequest(request)
		}
	}
	
	class func componentsFetchedResultsController(forSystem: System) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "system.id", forSystem.id)
		request.sortDescriptors = [NSSortDescriptor(key: ComponentManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func specialTestsFetchedResultsController(forComponent: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", forComponent.id)
		request.sortDescriptors = [NSSortDescriptor(key: SpecialTestManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func imageLinksFetchedResultsController(forSpecialTest: SpecialTest) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ImageLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "specialTest.id", forSpecialTest.id)
		request.sortDescriptors = [NSSortDescriptor(key: ImageLinkManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func videoLinksFetchedResultsController(forExamTechnique: ExamTechnique) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "examTechnique.id", forExamTechnique.id)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func videoLinksFetchedResultsController(forSpecialTest: SpecialTest) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "specialTest.id", forSpecialTest.id)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func rangesOfMotionFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: RangeOfMotionManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: RangeOfMotionManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func musclesFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: MuscleManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: MuscleManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func palpationsFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: PalpationManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: PalpationManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func examTechniquesFetchedResultsController(forSystem: System) -> NSFetchedResultsController {
		let request = NSFetchRequest(entityName: ExamTechniqueManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "system.id", forSystem.id)
		request.sortDescriptors = [NSSortDescriptor(key: ExamTechniqueManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}

}