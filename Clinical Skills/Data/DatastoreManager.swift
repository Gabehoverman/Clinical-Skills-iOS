//
//  DatastoreManager.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatastoreManager : NSObject {
	
	// MARK: - Properties
	
	let managedObjectContext: NSManagedObjectContext
	let delegate: DatastoreManagerDelegate?
	
	// MARK: - Initializers
	
	init(delegate: DatastoreManagerDelegate?) {
		self.managedObjectContext = NSManagedObjectContext()
		self.managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
		self.delegate = delegate
		super.init()
	}
	
	// MARK: - Store Collection Methods
	
	func storeSystems(systems: [System]) {
		self.delegate?.didBeginStoring?()
		for system in systems {
			self.storeSystem(system)
		}
		self.save()
		
	}

	func storeExamTechniques(examTechniques: [ExamTechnique]) {
		self.delegate?.didBeginStoring?()
		for examTechnique in examTechniques {
			self.storeExamTechnique(examTechnique)
		}
		self.save()
		
	}
	
	func storeComponents(components: [Component]) {
		self.delegate?.didBeginStoring?()
		for component in components {
			self.storeComponent(component)
		}
		self.save()
	}
	
	func storePalpations(palpations: [Palpation]) {
		self.delegate?.didBeginStoring?()
		for palpation in palpations {
			self.storePalpation(palpation)
		}
		self.save()
	}
	
	func storeRangesOfMotion(rangesOfMotion: [RangeOfMotion]) {
		self.delegate?.didBeginStoring?()
		for rangeOfMotion in rangesOfMotion {
			self.storeRangeOfMotion(rangeOfMotion)
		}
		self.save()
	}
	
	func storeMuscles(muscles: [Muscle]) {
		self.delegate?.didBeginStoring?()
		for muscle in muscles {
			self.storeMuscle(muscle)
		}
		self.save()
	}
	
	func storeSpecialTests(specialTests: [SpecialTest]) {
		self.delegate?.didBeginStoring?()
		for specialTest in specialTests {
			self.storeSpecialTest(specialTest)
		}
		self.save()
	}
	
	func storeImageLinks(imageLinks: [ImageLink]) {
		self.delegate?.didBeginStoring?()
		for imageLink in imageLinks {
			self.storeImageLink(imageLink)
		}
	}
	
	func storeVideoLinks(videoLinks: [VideoLink]) {
		self.delegate?.didBeginStoring?()
		for videoLink in videoLinks {
			self.storeVideoLink(videoLink)
		}
		self.save()
	}
	
	// MARK: - Store Instance Methods
	
	func storeSystem(system: System) {
		if !self.containsSystemWithID(system.id) {
			let entity = NSEntityDescription.entityForName(SystemManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SystemManagedObject {
				newManagedSystem.id = system.id
				newManagedSystem.name = system.name
				newManagedSystem.details = system.details
			}
		}
	}
	
	func storeExamTechnique(examTechnique: ExamTechnique) {
		if !self.containsExamTechniqueWithID(examTechnique.id) {
			let entity = NSEntityDescription.entityForName(ExamTechniqueManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedExamTechnique = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ExamTechniqueManagedObject {
				newManagedExamTechnique.id = examTechnique.id
				newManagedExamTechnique.name = examTechnique.name
				newManagedExamTechnique.details = examTechnique.details
				if let managedSystem = self.retrieveSystemWithID(examTechnique.system.id) {
					newManagedExamTechnique.system = managedSystem
				}
			}
		}
	}
	
	func storeComponent(component: Component) {
		if !self.containsComponentWithID(component.id) {
			let entity = NSEntityDescription.entityForName(ComponentManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedComponent = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ComponentManagedObject {
				newManagedComponent.id = component.id
				newManagedComponent.name = component.name
				newManagedComponent.inspection = component.inspection
				newManagedComponent.notes = component.notes
				if let managedSystem = self.retrieveSystemWithID(component.system.id) {
					newManagedComponent.system = managedSystem
				}
			}
		}
	}
	
	func storePalpation(palpation: Palpation) {
		if !self.containsPalpationWithID(palpation.id) {
			let entity = NSEntityDescription.entityForName(PalpationManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedPalpation = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? PalpationManagedObject {
				newManagedPalpation.id = palpation.id
				newManagedPalpation.structure = palpation.structure
				newManagedPalpation.details = palpation.details
				newManagedPalpation.notes = palpation.notes
				if let managedComponent = self.retrieveComponentWithID(palpation.component.id) {
					newManagedPalpation.component = managedComponent
				}
			}
		}
	}
	
	func storeRangeOfMotion(rangeOfMotion: RangeOfMotion) {
		if !self.containsRangeOfMotionWithID(rangeOfMotion.id) {
			let entity = NSEntityDescription.entityForName(RangeOfMotionManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedRangeOfMotion = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? RangeOfMotionManagedObject {
				newManagedRangeOfMotion.id = rangeOfMotion.id
				newManagedRangeOfMotion.motion = rangeOfMotion.motion
				newManagedRangeOfMotion.degrees = rangeOfMotion.degrees
				newManagedRangeOfMotion.notes = rangeOfMotion.notes
				if let managedComponent = self.retrieveComponentWithID(rangeOfMotion.component.id) {
					newManagedRangeOfMotion.component = managedComponent
				}
			}
		}
	}
	
	func storeMuscle(muscle: Muscle) {
		if !self.containsMuscleWithID(muscle.id) {
			let entity = NSEntityDescription.entityForName(MuscleManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedMuscle = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? MuscleManagedObject {
				newManagedMuscle.id = muscle.id
				newManagedMuscle.name = muscle.name
				if let managedComponent = self.retrieveComponentWithID(muscle.component.id) {
					newManagedMuscle.component = managedComponent
				}
			}
		}
	}
	
	func storeSpecialTest(specialTest: SpecialTest) {
		if !self.containsSpecialTestWithID(specialTest.id) {
			let entity = NSEntityDescription.entityForName(SpecialTestManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSpecialTest = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SpecialTestManagedObject {
				newManagedSpecialTest.id = specialTest.id
				newManagedSpecialTest.name = specialTest.name
				newManagedSpecialTest.positiveSign = specialTest.positiveSign
				newManagedSpecialTest.indication = specialTest.indication
				newManagedSpecialTest.notes = specialTest.notes
				if let managedComponent = self.retrieveComponentWithID(specialTest.component.id) {
					newManagedSpecialTest.component = managedComponent
				}
			}
		}
	}
	
	func storeImageLink(imageLink: ImageLink) {
		if !self.containsImageLinkWithID(imageLink.id) {
			let entity = NSEntityDescription.entityForName(ImageLinkManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedImageLink = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ImageLinkManagedObject {
				newManagedImageLink.id = imageLink.id
				newManagedImageLink.title = imageLink.title
				newManagedImageLink.link = imageLink.link
				if let managedSpecialTest = self.retrieveSpecialTestWithID(imageLink.specialTest.id) {
					newManagedImageLink.specialTest = managedSpecialTest
				}
			}
		}
	}
	
	func storeVideoLink(videoLink: VideoLink) {
		if !self.containsVideoLinkWithID(videoLink.id) {
			let entity = NSEntityDescription.entityForName(VideoLinkManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedVideoLink = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? VideoLinkManagedObject {
				newManagedVideoLink.id = videoLink.id
				newManagedVideoLink.title = videoLink.title
				newManagedVideoLink.link = videoLink.link
				if videoLink.specialTest != nil {
					if let managedSpecialTest = self.retrieveSpecialTestWithID(videoLink.specialTest!.id) {
						newManagedVideoLink.specialTest = managedSpecialTest
					}
				}
				if videoLink.examTechnique != nil {
					if let managedExamTechnique = self.retrieveExamTechniqueWithID(videoLink.examTechnique!.id) {
						newManagedVideoLink.examTechnique = managedExamTechnique
					}
				}
			}
		}
	}
	
	// MARK: - Retrieve Methods
	
	func retrieveSystemWithID(id: Int32) -> SystemManagedObject? {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", SystemManagedObject.propertyKeys.id, id)
		if let managedSystem = try! self.managedObjectContext.executeFetchRequest(request).first as? SystemManagedObject {
			return managedSystem
		}
		return nil
	}
	
	func retrieveExamTechniqueWithID(id: Int32) -> ExamTechniqueManagedObject? {
		let request = NSFetchRequest(entityName: ExamTechniqueManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ExamTechniqueManagedObject.propertyKeys.id, id)
		if let managedExamTechnique = try! self.managedObjectContext.executeFetchRequest(request).first as? ExamTechniqueManagedObject {
			return managedExamTechnique
		}
		return nil
	}
	
	func retrieveComponentWithID(id: Int32) -> ComponentManagedObject? {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		if let managedComponent = try! self.managedObjectContext.executeFetchRequest(request).first as? ComponentManagedObject {
			return managedComponent
		}
		return nil
	}
	
	func retrievePalpationWithID(id: Int32) -> PalpationManagedObject? {
		let request = NSFetchRequest(entityName: PalpationManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", PalpationManagedObject.propertyKeys.id, id)
		if let managedPalpation = try! self.managedObjectContext.executeFetchRequest(request).first as? PalpationManagedObject {
			return managedPalpation
		}
		return nil
	}
	
	func retrieveRangeOfMotionWithID(id: Int32) -> RangeOfMotionManagedObject? {
		let request = NSFetchRequest(entityName: RangeOfMotionManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", RangeOfMotionManagedObject.propertyKeys.id, id)
		if let managedRangeOfMotion = try! self.managedObjectContext.executeFetchRequest(request).first as? RangeOfMotionManagedObject {
			return managedRangeOfMotion
		}
		return nil
	}
	
	func retrieveMuscleWithID(id: Int32) -> MuscleManagedObject? {
		let request = NSFetchRequest(entityName: MuscleManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", MuscleManagedObject.propertyKeys.id, id)
		if let managedMuscle = try! self.managedObjectContext.executeFetchRequest(request).first as? MuscleManagedObject {
			return managedMuscle
		}
		return nil
	}
	
	func retrieveSpecialTestWithID(id: Int32) -> SpecialTestManagedObject? {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", SpecialTestManagedObject.propertyKeys.id, id)
		if let managedSpecialTest = try! self.managedObjectContext.executeFetchRequest(request).first as? SpecialTestManagedObject {
			return managedSpecialTest
		}
		return nil
	}
	
	func retrieveImageLinkWithID(id: Int32) -> ImageLinkManagedObject? {
		let request = NSFetchRequest(entityName: ImageLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ImageLinkManagedObject.propertyKeys.id, id)
		if let managedImageLink = try! self.managedObjectContext.executeFetchRequest(request).first as? ImageLinkManagedObject {
			return managedImageLink
		}
		return nil
	}
	
	func retrieveVideoLinkWithID(id: Int32) -> VideoLinkManagedObject? {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", VideoLinkManagedObject.propertyKeys.id, id)
		if let managedVideoLink = try! self.managedObjectContext.executeFetchRequest(request).first as? VideoLinkManagedObject {
			return managedVideoLink
		}
		return nil
	}
	
	// MARK: - Contains Methods
	
	func containsSystemWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", SystemManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsExamTechniqueWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: ExamTechniqueManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ExamTechniqueManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsComponentWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsPalpationWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: PalpationManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", PalpationManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsRangeOfMotionWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: RangeOfMotionManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", RangeOfMotionManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsMuscleWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: MuscleManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", MuscleManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsSpecialTestWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsImageLinkWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: ImageLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ImageLinkManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsVideoLinkWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", VideoLinkManagedObject.propertyKeys.id , id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	// MARK: - Save Methods
	
	func save() {
		do {
			print("\(self.managedObjectContext.insertedObjects.count) Objects to be Inserted")
			try self.managedObjectContext.save()
			self.delegate?.didFinishStoring?()
			print("Saved Managed Object Context\n")
		} catch let error as NSError {
			self.delegate?.didFinishStoringWithError?(error)
			print("Error Saving Managed Object Context")
			print("\(error)\n")
		}
	}
}

// MARK: - Datastore Manager Protocol

@objc protocol DatastoreManagerDelegate {
	optional func didBeginStoring()
	optional func didFinishStoring()
	optional func didFinishStoringWithError(error: NSError)
}