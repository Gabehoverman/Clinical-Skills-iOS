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
		self.managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
		self.managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
		self.delegate = delegate
		super.init()
	}
	
	// MARK: - Store Collection Methods
	
	func store(objects: [AnyObject]) {
		self.delegate?.didBeginStoring?()
		for object in objects {
			switch object {
				case is System:
					self.storeSystem(object as! System)
				case is ExamTechnique:
					self.storeExamTechnique(object as! ExamTechnique)
				case is Component:
					self.storeComponent(object as! Component)
				case is Palpation:
					self.storePalpation(object as! Palpation)
				case is RangeOfMotion:
					self.storeRangeOfMotion(object as! RangeOfMotion)
				case is Muscle:
					self.storeMuscle(object as! Muscle)
				case is SpecialTest:
					self.storeSpecialTest(object as! SpecialTest)
				case is ImageLink:
					self.storeImageLink(object as! ImageLink)
				case is VideoLink:
					self.storeVideoLink(object as! VideoLink)
				default:
					print("ERROR!!!!")
			}
		}
		self.save()
	}
	
	// MARK: - Store Instance Methods
	
	private func storeSystem(system: System) {
		if self.containsObjectWithID(system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) {
			self.updateSystemWithID(system.id, toSystem: system)
		} else {
			let entity = NSEntityDescription.entityForName(SystemManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SystemManagedObject {
				newManagedSystem.id = system.id
				newManagedSystem.name = system.name
				newManagedSystem.details = system.details
			}
		}
	}
	
	private func storeExamTechnique(examTechnique: ExamTechnique) {
		if self.containsObjectWithID(examTechnique.id, entityName: ExamTechniqueManagedObject.entityName, idPropertyKey: ExamTechniqueManagedObject.propertyKeys.id) {
			self.updateExamTechniqueWithID(examTechnique.id, toExamTechnique: examTechnique)
		} else {
			let entity = NSEntityDescription.entityForName(ExamTechniqueManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedExamTechnique = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ExamTechniqueManagedObject {
				newManagedExamTechnique.id = examTechnique.id
				newManagedExamTechnique.name = examTechnique.name
				newManagedExamTechnique.details = examTechnique.details
				if let managedSystem = self.retrieveObjectWithID(examTechnique.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
					newManagedExamTechnique.system = managedSystem
				}
			}
		}
	}
	
	private func storeComponent(component: Component) {
		if self.containsObjectWithID(component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) {
			self.updateComponentWithID(component.id, toComponent: component)
		} else {
			let entity = NSEntityDescription.entityForName(ComponentManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedComponent = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ComponentManagedObject {
				newManagedComponent.id = component.id
				newManagedComponent.name = component.name
				newManagedComponent.inspection = component.inspection
				newManagedComponent.notes = component.notes
				if let managedSystem = self.retrieveObjectWithID(component.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
					newManagedComponent.system = managedSystem
				}
			}
		}
	}
	
	private func storePalpation(palpation: Palpation) {
		if self.containsObjectWithID(palpation.id, entityName: PalpationManagedObject.entityName, idPropertyKey: PalpationManagedObject.propertyKeys.id) {
			self.updatePalpationWithID(palpation.id, toPalpation: palpation)
		} else {
			let entity = NSEntityDescription.entityForName(PalpationManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedPalpation = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? PalpationManagedObject {
				newManagedPalpation.id = palpation.id
				newManagedPalpation.structure = palpation.structure
				newManagedPalpation.details = palpation.details
				newManagedPalpation.notes = palpation.notes
				if let managedComponent = self.retrieveObjectWithID(palpation.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
					newManagedPalpation.component = managedComponent
				}
			}
		}
	}
	
	private func storeRangeOfMotion(rangeOfMotion: RangeOfMotion) {
		if self.containsObjectWithID(rangeOfMotion.id, entityName: RangeOfMotionManagedObject.entityName, idPropertyKey: RangeOfMotionManagedObject.propertyKeys.id) {
			self.updateRangeOfMotionWithID(rangeOfMotion.id, toRangeOfMotion: rangeOfMotion)
		} else {
			let entity = NSEntityDescription.entityForName(RangeOfMotionManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedRangeOfMotion = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? RangeOfMotionManagedObject {
				newManagedRangeOfMotion.id = rangeOfMotion.id
				newManagedRangeOfMotion.motion = rangeOfMotion.motion
				newManagedRangeOfMotion.degrees = rangeOfMotion.degrees
				newManagedRangeOfMotion.notes = rangeOfMotion.notes
				if let managedComponent = self.retrieveObjectWithID(rangeOfMotion.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
					newManagedRangeOfMotion.component = managedComponent
				}
			}
		}
	}
	
	private func storeMuscle(muscle: Muscle) {
		if self.containsObjectWithID(muscle.id, entityName: MuscleManagedObject.entityName, idPropertyKey: MuscleManagedObject.propertyKeys.id) {
			self.updateMuscleWithID(muscle.id, toMuscle: muscle)
		} else {
			let entity = NSEntityDescription.entityForName(MuscleManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedMuscle = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? MuscleManagedObject {
				newManagedMuscle.id = muscle.id
				newManagedMuscle.name = muscle.name
				if let managedComponent = self.retrieveObjectWithID(muscle.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
					newManagedMuscle.component = managedComponent
				}
			}
		}
	}
	
	private func storeSpecialTest(specialTest: SpecialTest) {
		if self.containsObjectWithID(specialTest.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) {
			self.updateSpecialTestWithID(specialTest.id, toSpecialTest: specialTest)
		} else {
			let entity = NSEntityDescription.entityForName(SpecialTestManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSpecialTest = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SpecialTestManagedObject {
				newManagedSpecialTest.id = specialTest.id
				newManagedSpecialTest.name = specialTest.name
				newManagedSpecialTest.positiveSign = specialTest.positiveSign
				newManagedSpecialTest.indication = specialTest.indication
				newManagedSpecialTest.notes = specialTest.notes
				if let managedComponent = self.retrieveObjectWithID(specialTest.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
					newManagedSpecialTest.component = managedComponent
				}
			}
		}
	}
	
	private func storeImageLink(imageLink: ImageLink) {
		if self.containsObjectWithID(imageLink.id, entityName: ImageLinkManagedObject.entityName, idPropertyKey: ImageLinkManagedObject.propertyKeys.id) {
			self.updateImageLinkWithID(imageLink.id, toImageLink: imageLink)
		} else {
			let entity = NSEntityDescription.entityForName(ImageLinkManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedImageLink = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ImageLinkManagedObject {
				newManagedImageLink.id = imageLink.id
				newManagedImageLink.title = imageLink.title
				newManagedImageLink.link = imageLink.link
				if let managedSpecialTest = self.retrieveObjectWithID(imageLink.specialTest.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
					newManagedImageLink.specialTest = managedSpecialTest
				}
			}
		}
	}
	
	private func storeVideoLink(videoLink: VideoLink) {
		if self.containsObjectWithID(videoLink.id, entityName: VideoLinkManagedObject.entityName, idPropertyKey: VideoLinkManagedObject.propertyKeys.id) {
			self.updateVideoLinkWithID(videoLink.id, toVideoLink: videoLink)
		} else {
			let entity = NSEntityDescription.entityForName(VideoLinkManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedVideoLink = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? VideoLinkManagedObject {
				newManagedVideoLink.id = videoLink.id
				newManagedVideoLink.title = videoLink.title
				newManagedVideoLink.link = videoLink.link
				if videoLink.specialTest != nil {
				if let managedSpecialTest = self.retrieveObjectWithID(videoLink.specialTest!.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
						newManagedVideoLink.specialTest = managedSpecialTest
					}
				}
				if videoLink.examTechnique != nil {
					if let managedExamTechnique = self.retrieveObjectWithID(videoLink.examTechnique!.id, entityName: ExamTechniqueManagedObject.entityName, idPropertyKey: ExamTechniqueManagedObject.propertyKeys.id) as? ExamTechniqueManagedObject {
						newManagedVideoLink.examTechnique = managedExamTechnique
					}
				}
			}
		}
	}
	
	// MARK: - Update Methods
	
	private func updateSystemWithID(id: Int32, toSystem: System) {
		if let managedSystem = self.retrieveObjectWithID(id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
			if (managedSystem != toSystem) {
				managedSystem.name = toSystem.name
				managedSystem.details = toSystem.details
			}
		}
	}
	
	private func updateComponentWithID(id: Int32, toComponent: Component) {
		if let managedComponent = self.retrieveObjectWithID(id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
			managedComponent.name = toComponent.name
			managedComponent.inspection = toComponent.inspection
			managedComponent.notes = toComponent.notes
			if let managedSystem = self.retrieveObjectWithID(toComponent.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
				managedComponent.system = managedSystem
			}
		}
	}
	
	private func updateExamTechniqueWithID(id: Int32, toExamTechnique: ExamTechnique) {
		print("Updating Exam Techniques")
		if let managedExamTechnique = self.retrieveObjectWithID(id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ExamTechniqueManagedObject {
			managedExamTechnique.name = toExamTechnique.name
			managedExamTechnique.details = toExamTechnique.details
			if let managedSystem = self.retrieveObjectWithID(toExamTechnique.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
				managedExamTechnique.system = managedSystem
			}
		}
	}
	
	private func updatePalpationWithID(id: Int32, toPalpation: Palpation) {
		if let managedPalpation = self.retrieveObjectWithID(id, entityName: PalpationManagedObject.entityName, idPropertyKey: PalpationManagedObject.propertyKeys.id) as? PalpationManagedObject {
			managedPalpation.structure = toPalpation.structure
			managedPalpation.details = toPalpation.details
			managedPalpation.notes = toPalpation.notes
			if let managedComponent = self.retrieveObjectWithID(toPalpation.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedPalpation.component = managedComponent
			}
		}
	}
	
	private func updateRangeOfMotionWithID(id: Int32, toRangeOfMotion: RangeOfMotion) {
		if let managedRangeOfMotion = self.retrieveObjectWithID(id, entityName: RangeOfMotionManagedObject.entityName, idPropertyKey: RangeOfMotionManagedObject.propertyKeys.id) as? RangeOfMotionManagedObject {
			managedRangeOfMotion.motion = toRangeOfMotion.motion
			managedRangeOfMotion.degrees = toRangeOfMotion.degrees
			managedRangeOfMotion.notes = toRangeOfMotion.notes
			if let managedComponent = self.retrieveObjectWithID(toRangeOfMotion.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedRangeOfMotion.component = managedComponent
			}
		}
	}
	
	private func updateMuscleWithID(id: Int32, toMuscle: Muscle) {
		if let managedMuscle = self.retrieveObjectWithID(id, entityName: MuscleManagedObject.entityName, idPropertyKey: MuscleManagedObject.propertyKeys.id) as? MuscleManagedObject {
			managedMuscle.name = toMuscle.name
			if let managedComponent = self.retrieveObjectWithID(toMuscle.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedMuscle.component = managedComponent
			}
		}
	}
	
	private func updateSpecialTestWithID(id: Int32, toSpecialTest: SpecialTest) {
		if let managedSpecialTest = self.retrieveObjectWithID(id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
			managedSpecialTest.name = toSpecialTest.name
			managedSpecialTest.positiveSign = toSpecialTest.positiveSign
			managedSpecialTest.indication = toSpecialTest.indication
			managedSpecialTest.notes = toSpecialTest.notes
			if let managedComponent = self.retrieveObjectWithID(toSpecialTest.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedSpecialTest.component = managedComponent
			}
		}
	}
	
	private func updateImageLinkWithID(id: Int32, toImageLink: ImageLink) {
		if let managedImageLink = self.retrieveObjectWithID(id, entityName: ImageLinkManagedObject.entityName, idPropertyKey: ImageLinkManagedObject.propertyKeys.id) as? ImageLinkManagedObject {
			managedImageLink.title = toImageLink.title
			managedImageLink.link = toImageLink.link
			if let managedSpecialTest = self.retrieveObjectWithID(toImageLink.specialTest.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
				managedImageLink.specialTest = managedSpecialTest
			}
		}
	}
	
	private func updateVideoLinkWithID(id: Int32, toVideoLink: VideoLink) {
		if let managedVideoLink = self.retrieveObjectWithID(id, entityName: VideoLinkManagedObject.entityName, idPropertyKey: VideoLinkManagedObject.propertyKeys.id) as? VideoLinkManagedObject {
			managedVideoLink.title = toVideoLink.title
			managedVideoLink.link = toVideoLink.link
			if toVideoLink.examTechnique != nil {
				if let managedExamTechnique = self.retrieveObjectWithID(toVideoLink.specialTest!.id, entityName: ExamTechniqueManagedObject.entityName, idPropertyKey: ExamTechniqueManagedObject.propertyKeys.id) as? ExamTechniqueManagedObject {
					managedVideoLink.examTechnique = managedExamTechnique
				}
			}
			if toVideoLink.specialTest != nil {
				if let managedSpecialTest = self.retrieveObjectWithID(toVideoLink.specialTest!.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
					managedVideoLink.specialTest = managedSpecialTest
				}
			}
		}
	}
	
	// MARK: - Delete Methods
	
	private func deleteObjectsForEntity(entityName: String, withPredicate: NSPredicate) {
		let request = NSFetchRequest(entityName: entityName)
		request.predicate = withPredicate
		if let managedObjects = try! self.managedObjectContext.executeFetchRequest(request) as? [NSManagedObject] {
			for managedObject in managedObjects {
				self.managedObjectContext.deleteObject(managedObject)
			}
		}
	}
	
	// MARK: - Retrieve Methods
	
	private func retrieveObjectWithID(id: Int32, entityName: String, idPropertyKey: String) -> NSManagedObject? {
		let request = NSFetchRequest(entityName: entityName)
		request.predicate = NSPredicate(format: "%K = %d", idPropertyKey, id)
		return try! self.managedObjectContext.executeFetchRequest(request).first as? NSManagedObject
	}
	
	// MARK: - Contains Methods
	
	private func containsObjectWithID(id: Int32, entityName: String, idPropertyKey: String) -> Bool {
		let request = NSFetchRequest(entityName: entityName)
		request.predicate = NSPredicate(format: "%K = %d", idPropertyKey, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	// MARK: - Save Methods
	
	private func save() {
		do {
			print("\(self.managedObjectContext.insertedObjects.count) Objects to be Inserted")
			print("\(self.managedObjectContext.updatedObjects.count) Objects to be Updated")
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