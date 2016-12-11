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
		self.managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		self.managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator
		self.delegate = delegate
		super.init()
	}
	
	// MARK: - Store Collection Methods
	
	func store(_ objects: [AnyObject]) {
		self.delegate?.didBeginStoring?()
		if objects is [PersonnelAcknowledgement] {
			self.deleteObjectsForEntity(PersonnelAcknowledgementManagedObject.entityName)
			for object in objects {
				self.storePersonnelAcknowledgement(object as! PersonnelAcknowledgement)
			}
		} else if objects is [SoftwareAcknowledgement] {
			self.deleteObjectsForEntity(SoftwareAcknowledgementManagedObject.entityName)
			for object in objects {
				self.storeSoftwareAcknowledgement(object as! SoftwareAcknowledgement)
			}
		} else if objects is [System] {
			self.deleteObjectsForEntity(SystemManagedObject.entityName)
			for object in objects {
				self.storeSystem(object as! System)
			}
		} else if objects is [ExamTechnique] {
			self.deleteObjectsForEntity(ExamTechniqueManagedObject.entityName)
			for object in objects {
				self.storeExamTechnique(object as! ExamTechnique)
			}
		} else if objects is [Component] {
			self.deleteObjectsForEntity(ComponentManagedObject.entityName)
			for object in objects {
				self.storeComponent(object as! Component)
			}
		} else if objects is [Palpation] {
			self.deleteObjectsForEntity(PalpationManagedObject.entityName)
			for object in objects {
				self.storePalpation(object as! Palpation)
			}
		} else if objects is [RangeOfMotion] {
			self.deleteObjectsForEntity(RangeOfMotionManagedObject.entityName)
			for object in objects {
				self.storeRangeOfMotion(object as! RangeOfMotion)
			}
		} else if objects is [Muscle] {
			self.deleteObjectsForEntity(MuscleManagedObject.entityName)
			for object in objects {
				self.storeMuscle(object as! Muscle)
			}
		} else if objects is [SpecialTest] {
			self.deleteObjectsForEntity(SpecialTestManagedObject.entityName)
			for object in objects {
				self.storeSpecialTest(object as! SpecialTest)
			}
		} else if objects is [ImageLink] {
			self.deleteObjectsForEntity(ImageLinkManagedObject.entityName)
			for object in objects {
				self.storeImageLink(object as! ImageLink)
			}
		} else if objects is [VideoLink] {
			self.deleteObjectsForEntity(VideoLinkManagedObject.entityName)
			for object in objects {
				self.storeVideoLink(object as! VideoLink)
			}
		}
		self.save()
	}
	
	// MARK: - Store Instance Methods
	
	fileprivate func storePersonnelAcknowledgement(_ personnelAcknowledgement: PersonnelAcknowledgement) {
		if self.containsObjectWithID(personnelAcknowledgement.id, entityName: PersonnelAcknowledgementManagedObject.entityName, idPropertyKey: PersonnelAcknowledgementManagedObject.propertyKeys.id) {
			self.updatePersonnelAcknowledgementWithID(personnelAcknowledgement.id, toPersonnelAcknowledgement: personnelAcknowledgement)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: PersonnelAcknowledgementManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedPersonnelAcknowledgement = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? PersonnelAcknowledgementManagedObject {
				newManagedPersonnelAcknowledgement.id = personnelAcknowledgement.id
				newManagedPersonnelAcknowledgement.name = personnelAcknowledgement.name
				newManagedPersonnelAcknowledgement.role = personnelAcknowledgement.role
				newManagedPersonnelAcknowledgement.notes = personnelAcknowledgement.notes
			}
		}
	}
	
	fileprivate func storeSoftwareAcknowledgement(_ softwareAcknowledgement: SoftwareAcknowledgement) {
		if self.containsObjectWithID(softwareAcknowledgement.id, entityName: SoftwareAcknowledgementManagedObject.entityName, idPropertyKey: SoftwareAcknowledgementManagedObject.propertyKeys.id) {
			self.updateSoftwareAcknowledgementWithID(softwareAcknowledgement.id, toSoftwareAcknowledgement: softwareAcknowledgement)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: SoftwareAcknowledgementManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedSoftwareAcknowledgement = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? SoftwareAcknowledgementManagedObject {
				newManagedSoftwareAcknowledgement.id = softwareAcknowledgement.id
				newManagedSoftwareAcknowledgement.name = softwareAcknowledgement.name
				newManagedSoftwareAcknowledgement.link = softwareAcknowledgement.link
			}
		}
	}
	
	fileprivate func storeSystem(_ system: System) {
		if self.containsObjectWithID(system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) {
			self.updateSystemWithID(system.id, toSystem: system)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: SystemManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedSystem = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? SystemManagedObject {
				newManagedSystem.id = system.id
				newManagedSystem.name = system.name
				newManagedSystem.details = system.details
			}
		}
	}
	
	fileprivate func storeExamTechnique(_ examTechnique: ExamTechnique) {
		if self.containsObjectWithID(examTechnique.id, entityName: ExamTechniqueManagedObject.entityName, idPropertyKey: ExamTechniqueManagedObject.propertyKeys.id) {
			self.updateExamTechniqueWithID(examTechnique.id, toExamTechnique: examTechnique)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: ExamTechniqueManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedExamTechnique = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? ExamTechniqueManagedObject {
				newManagedExamTechnique.id = examTechnique.id
				newManagedExamTechnique.name = examTechnique.name
				newManagedExamTechnique.details = examTechnique.details
				if let managedSystem = self.retrieveObjectWithID(examTechnique.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
					newManagedExamTechnique.system = managedSystem
				}
			}
		}
	}
	
	fileprivate func storeComponent(_ component: Component) {
		if self.containsObjectWithID(component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) {
			self.updateComponentWithID(component.id, toComponent: component)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: ComponentManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedComponent = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? ComponentManagedObject {
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
	
	fileprivate func storePalpation(_ palpation: Palpation) {
		if self.containsObjectWithID(palpation.id, entityName: PalpationManagedObject.entityName, idPropertyKey: PalpationManagedObject.propertyKeys.id) {
			self.updatePalpationWithID(palpation.id, toPalpation: palpation)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: PalpationManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedPalpation = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? PalpationManagedObject {
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
	
	fileprivate func storeRangeOfMotion(_ rangeOfMotion: RangeOfMotion) {
		if self.containsObjectWithID(rangeOfMotion.id, entityName: RangeOfMotionManagedObject.entityName, idPropertyKey: RangeOfMotionManagedObject.propertyKeys.id) {
			self.updateRangeOfMotionWithID(rangeOfMotion.id, toRangeOfMotion: rangeOfMotion)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: RangeOfMotionManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedRangeOfMotion = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? RangeOfMotionManagedObject {
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
	
	fileprivate func storeMuscle(_ muscle: Muscle) {
		if self.containsObjectWithID(muscle.id, entityName: MuscleManagedObject.entityName, idPropertyKey: MuscleManagedObject.propertyKeys.id) {
			self.updateMuscleWithID(muscle.id, toMuscle: muscle)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: MuscleManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedMuscle = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? MuscleManagedObject {
				newManagedMuscle.id = muscle.id
				newManagedMuscle.name = muscle.name
				if let managedComponent = self.retrieveObjectWithID(muscle.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
					newManagedMuscle.component = managedComponent
				}
			}
		}
	}
	
	fileprivate func storeSpecialTest(_ specialTest: SpecialTest) {
		if self.containsObjectWithID(specialTest.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) {
			self.updateSpecialTestWithID(specialTest.id, toSpecialTest: specialTest)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: SpecialTestManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedSpecialTest = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? SpecialTestManagedObject {
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
	
	fileprivate func storeImageLink(_ imageLink: ImageLink) {
		if self.containsObjectWithID(imageLink.id, entityName: ImageLinkManagedObject.entityName, idPropertyKey: ImageLinkManagedObject.propertyKeys.id) {
			self.updateImageLinkWithID(imageLink.id, toImageLink: imageLink)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: ImageLinkManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedImageLink = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? ImageLinkManagedObject {
				newManagedImageLink.id = imageLink.id
				newManagedImageLink.title = imageLink.title
				newManagedImageLink.link = imageLink.link
				if let managedSpecialTest = self.retrieveObjectWithID(imageLink.specialTest.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
					newManagedImageLink.specialTest = managedSpecialTest
				}
			}
		}
	}
	
	fileprivate func storeVideoLink(_ videoLink: VideoLink) {
		if self.containsObjectWithID(videoLink.id, entityName: VideoLinkManagedObject.entityName, idPropertyKey: VideoLinkManagedObject.propertyKeys.id) {
			self.updateVideoLinkWithID(videoLink.id, toVideoLink: videoLink)
		} else {
			let entity = NSEntityDescription.entity(forEntityName: VideoLinkManagedObject.entityName, in: self.managedObjectContext)!
			if let newManagedVideoLink = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? VideoLinkManagedObject {
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
	
	fileprivate func updatePersonnelAcknowledgementWithID(_ id: Int32, toPersonnelAcknowledgement: PersonnelAcknowledgement) {
		if let managedPersonnelAcknowledgement = self.retrieveObjectWithID(id, entityName: PersonnelAcknowledgementManagedObject.entityName, idPropertyKey: PersonnelAcknowledgementManagedObject.propertyKeys.id) as? PersonnelAcknowledgementManagedObject {
			if (managedPersonnelAcknowledgement != toPersonnelAcknowledgement) {
				managedPersonnelAcknowledgement.name = toPersonnelAcknowledgement.name
				managedPersonnelAcknowledgement.role = toPersonnelAcknowledgement.role
				managedPersonnelAcknowledgement.notes = toPersonnelAcknowledgement.notes
			}
		}
	}
	
	fileprivate func updateSoftwareAcknowledgementWithID(_ id: Int32, toSoftwareAcknowledgement: SoftwareAcknowledgement) {
		if let managedSoftwareAcknowledgement = self.retrieveObjectWithID(id, entityName: SoftwareAcknowledgementManagedObject.entityName, idPropertyKey: SoftwareAcknowledgementManagedObject.propertyKeys.id) as? SoftwareAcknowledgementManagedObject {
			if (managedSoftwareAcknowledgement != toSoftwareAcknowledgement) {
				managedSoftwareAcknowledgement.name = toSoftwareAcknowledgement.name
				managedSoftwareAcknowledgement.link = toSoftwareAcknowledgement.link
			}
		}
	}
	
	fileprivate func updateSystemWithID(_ id: Int32, toSystem: System) {
		if let managedSystem = self.retrieveObjectWithID(id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
			if (managedSystem != toSystem) {
				managedSystem.name = toSystem.name
				managedSystem.details = toSystem.details
			}
		}
	}
	
	fileprivate func updateComponentWithID(_ id: Int32, toComponent: Component) {
		if let managedComponent = self.retrieveObjectWithID(id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
			managedComponent.name = toComponent.name
			managedComponent.inspection = toComponent.inspection
			managedComponent.notes = toComponent.notes
			if let managedSystem = self.retrieveObjectWithID(toComponent.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
				managedComponent.system = managedSystem
			}
		}
	}
	
	fileprivate func updateExamTechniqueWithID(_ id: Int32, toExamTechnique: ExamTechnique) {
		print("Updating Exam Techniques")
		if let managedExamTechnique = self.retrieveObjectWithID(id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ExamTechniqueManagedObject {
			managedExamTechnique.name = toExamTechnique.name
			managedExamTechnique.details = toExamTechnique.details
			if let managedSystem = self.retrieveObjectWithID(toExamTechnique.system.id, entityName: SystemManagedObject.entityName, idPropertyKey: SystemManagedObject.propertyKeys.id) as? SystemManagedObject {
				managedExamTechnique.system = managedSystem
			}
		}
	}
	
	fileprivate func updatePalpationWithID(_ id: Int32, toPalpation: Palpation) {
		if let managedPalpation = self.retrieveObjectWithID(id, entityName: PalpationManagedObject.entityName, idPropertyKey: PalpationManagedObject.propertyKeys.id) as? PalpationManagedObject {
			managedPalpation.structure = toPalpation.structure
			managedPalpation.details = toPalpation.details
			managedPalpation.notes = toPalpation.notes
			if let managedComponent = self.retrieveObjectWithID(toPalpation.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedPalpation.component = managedComponent
			}
		}
	}
	
	fileprivate func updateRangeOfMotionWithID(_ id: Int32, toRangeOfMotion: RangeOfMotion) {
		if let managedRangeOfMotion = self.retrieveObjectWithID(id, entityName: RangeOfMotionManagedObject.entityName, idPropertyKey: RangeOfMotionManagedObject.propertyKeys.id) as? RangeOfMotionManagedObject {
			managedRangeOfMotion.motion = toRangeOfMotion.motion
			managedRangeOfMotion.degrees = toRangeOfMotion.degrees
			managedRangeOfMotion.notes = toRangeOfMotion.notes
			if let managedComponent = self.retrieveObjectWithID(toRangeOfMotion.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedRangeOfMotion.component = managedComponent
			}
		}
	}
	
	fileprivate func updateMuscleWithID(_ id: Int32, toMuscle: Muscle) {
		if let managedMuscle = self.retrieveObjectWithID(id, entityName: MuscleManagedObject.entityName, idPropertyKey: MuscleManagedObject.propertyKeys.id) as? MuscleManagedObject {
			managedMuscle.name = toMuscle.name
			if let managedComponent = self.retrieveObjectWithID(toMuscle.component.id, entityName: ComponentManagedObject.entityName, idPropertyKey: ComponentManagedObject.propertyKeys.id) as? ComponentManagedObject {
				managedMuscle.component = managedComponent
			}
		}
	}
	
	fileprivate func updateSpecialTestWithID(_ id: Int32, toSpecialTest: SpecialTest) {
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
	
	fileprivate func updateImageLinkWithID(_ id: Int32, toImageLink: ImageLink) {
		if let managedImageLink = self.retrieveObjectWithID(id, entityName: ImageLinkManagedObject.entityName, idPropertyKey: ImageLinkManagedObject.propertyKeys.id) as? ImageLinkManagedObject {
			managedImageLink.title = toImageLink.title
			managedImageLink.link = toImageLink.link
			if let managedSpecialTest = self.retrieveObjectWithID(toImageLink.specialTest.id, entityName: SpecialTestManagedObject.entityName, idPropertyKey: SpecialTestManagedObject.propertyKeys.id) as? SpecialTestManagedObject {
				managedImageLink.specialTest = managedSpecialTest
			}
		}
	}
	
	fileprivate func updateVideoLinkWithID(_ id: Int32, toVideoLink: VideoLink) {
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
	
	func deleteObjectsForEntity(_ entityName: String) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		if let managedObjects = try! self.managedObjectContext.fetch(request) as? [NSManagedObject] {
			for managedObject in managedObjects {
				self.managedObjectContext.delete(managedObject)
			}
		}
		self.save()
	}
	
	// MARK: - Retrieve Methods
	
	fileprivate func retrieveObjectWithID(_ id: Int32, entityName: String, idPropertyKey: String) -> NSManagedObject? {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		request.predicate = NSPredicate(format: "%K = %d", idPropertyKey, id)
		return try! self.managedObjectContext.fetch(request).first as? NSManagedObject
	}
	
	// MARK: - Contains Methods
	
	fileprivate func containsObjectWithID(_ id: Int32, entityName: String, idPropertyKey: String) -> Bool {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		request.predicate = NSPredicate(format: "%K = %d", idPropertyKey, id)
		let results = try! self.managedObjectContext.fetch(request)
		return results.count != 0
	}
	
	// MARK: - Save Methods
	
	fileprivate func save() {
		do {
			print("\(self.managedObjectContext.deletedObjects.count) Objects to be Deleted")
			print("\(self.managedObjectContext.updatedObjects.count) Objects to be Updated")
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
	@objc optional func didBeginStoring()
	@objc optional func didFinishStoring()
	@objc optional func didFinishStoringWithError(_ error: NSError)
}
