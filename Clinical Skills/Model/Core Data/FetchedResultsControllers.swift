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
	
	static let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
	
	class func fetchedResultsControllerForRequest(_ request: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult> {
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
	}
	
	class func allPersonnelAcknowledgementsFetchedResultController() -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersonnelAcknowledgementManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: PersonnelAcknowledgementManagedObject.propertyKeys.id, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func allSoftwareAcknowledgementsFetchedResultController() -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: SoftwareAcknowledgementManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: SoftwareAcknowledgementManagedObject.propertyKeys.name, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func allSystemsFetchedResultController() -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: SystemManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.name, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func componentsFetchedResultsController(_ forSystem: System) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "system.id", forSystem.id)
		request.sortDescriptors = [NSSortDescriptor(key: ComponentManagedObject.propertyKeys.name, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func specialTestsFetchedResultsController(_ forComponent: Component) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", forComponent.id)
		request.sortDescriptors = [NSSortDescriptor(key: SpecialTestManagedObject.propertyKeys.name, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func imageLinksFetchedResultsController(_ forSpecialTest: SpecialTest) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: ImageLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "specialTest.id", forSpecialTest.id)
		request.sortDescriptors = [NSSortDescriptor(key: ImageLinkManagedObject.propertyKeys.title, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func videoLinksFetchedResultsController(_ forExamTechnique: ExamTechnique) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "examTechnique.id", forExamTechnique.id)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.title, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func videoLinksFetchedResultsController(_ forSpecialTest: SpecialTest) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "specialTest.id", forSpecialTest.id)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.title, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
    class func videoLinksFetchedResultsController(_ forSystem: System) -> NSFetchedResultsController<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: VideoLinkManagedObject.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.title, ascending: true)]
        return fetchedResultsControllerForRequest(request)
    }
    
	class func rangesOfMotionFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: RangeOfMotionManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: RangeOfMotionManagedObject.propertyKeys.motion, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func musclesFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: MuscleManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: MuscleManagedObject.propertyKeys.name, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func palpationsFetchedResultsController(forComponent component: Component) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: PalpationManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "component.id", component.id)
		request.sortDescriptors = [NSSortDescriptor(key: PalpationManagedObject.propertyKeys.structure, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}
	
	class func examTechniquesFetchedResultsController(_ forSystem: System) -> NSFetchedResultsController<NSFetchRequestResult> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: ExamTechniqueManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", "system.id", forSystem.id)
		request.sortDescriptors = [NSSortDescriptor(key: ExamTechniqueManagedObject.propertyKeys.name, ascending: true)]
		return fetchedResultsControllerForRequest(request)
	}

}
