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
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	let delegate: DatastoreManagerDelegate?
	
	// MARK: - Initializers
	
	init(delegate: DatastoreManagerDelegate?) {
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
		self.delegate?.didFinishStoring?()
		
	}
	
	func storeComponents(components: [Component]) {
		self.delegate?.didBeginStoring?()
		for component in components {
			self.storeComponent(component)
		}
		self.save()
		self.delegate?.didFinishStoring?()
	}
	
	func storeSpecialTests(specialTests: [SpecialTest]) {
		self.delegate?.didBeginStoring?()
		for specialTest in specialTests {
			self.storeSpecialTest(specialTest)
		}
		self.save()
		self.delegate?.didFinishStoring?()
	}
	
	func storeVideoLinks(videoLinks: [VideoLink]) {
		self.delegate?.didBeginStoring?()
		for videoLink in videoLinks {
			self.storeVideoLink(videoLink)
		}
		self.save()
		self.delegate?.didFinishStoring?()
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
	
	func storeComponent(component: Component) {
		if !self.containsComponentWithID(component.id) {
			let entity = NSEntityDescription.entityForName(ComponentManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedComponent = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? ComponentManagedObject {
				newManagedComponent.id = component.id
				newManagedComponent.name = component.name
				newManagedComponent.inspection = component.inspection
				newManagedComponent.notes = component.notes
				if let managedSystem = self.retrieveSystemWithID(component.parent.id) {
					newManagedComponent.parent = managedSystem
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
	
	func storeVideoLink(videoLink: VideoLink) {
		if !self.containsVideoLinkWithID(videoLink.id) {
			let entity = NSEntityDescription.entityForName(VideoLinkManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedVideoLink = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? VideoLinkManagedObject {
				newManagedVideoLink.id = videoLink.id
				newManagedVideoLink.title = videoLink.title
				newManagedVideoLink.link = videoLink.link
				if let managedSpecialTest = self.retrieveSpecialTestWithID(videoLink.specialTest.id) {
					newManagedVideoLink.specialTest = managedSpecialTest
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
	
	func retrieveComponentWithID(id: Int32) -> ComponentManagedObject? {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		if let managedComponent = try! self.managedObjectContext.executeFetchRequest(request).first as? ComponentManagedObject {
			return managedComponent
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
	
	func containsComponentWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsSpecialTestWithID(id: Int32) -> Bool {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
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
			print("Saved Managed Object Context\n")
		} catch {
			print("DatastoreManager: Error while saving Core Data Managed Object Context")
			print("\(error)")
		}
	}
	
	// MARK: - Clear Methods
	
	func clear(entityName: String) {
		do {
			let request = NSFetchRequest(entityName: entityName)
			var allObjects = try self.managedObjectContext.executeFetchRequest(request)
			print("\(allObjects.count) Objects to be Deleted")
			for object in allObjects {
				self.managedObjectContext.deleteObject(object as! NSManagedObject)
			}
			allObjects.removeAll(keepCapacity: false)
			try self.managedObjectContext.save()
		} catch {
			print("Error clearing Entity: \(entityName)")
		}
	}
	
	func clearSystems() {
		self.clear(SystemManagedObject.entityName)
	}
	
	func clearComponents() {
		self.clear(ComponentManagedObject.entityName)
	}
	
	func clearSpecialTests() {
		self.clear(SpecialTestManagedObject.entityName)
	}
	
	func clearVideoLinks() {
		self.clear(VideoLinkManagedObject.entityName)
	}
	
	func clearAll() {
		let allEntityNames = [SystemManagedObject.entityName, ComponentManagedObject.entityName, SpecialTestManagedObject.entityName, VideoLinkManagedObject.entityName]
		for entityName in allEntityNames {
			self.clear(entityName)
		}
	}
	
	// MARK: - Print Methods
	
	func printSystems() {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.id, ascending: true)]
		if let allManagedSystems = try! self.managedObjectContext.executeFetchRequest(request) as? [SystemManagedObject] {
			print("MANAGED SYSTEMS:")
			for managedSystem in allManagedSystems {
				print("\t\(managedSystem)")
			}
		}
		print("")
	}
	
	func printComponents() {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: ComponentManagedObject.propertyKeys.id, ascending: true)]
		if let allManagedComponents = try! self.managedObjectContext.executeFetchRequest(request) as? [ComponentManagedObject] {
			print("MANAGED COMPONENTS:")
			for managedComponent in allManagedComponents {
				print("\t\(managedComponent)")
			}
		}
		print("")
	}
	
	func printSpecialTests() {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: SpecialTestManagedObject.propertyKeys.id, ascending: true)]
		if let allManagedSpecialLinks = try! self.managedObjectContext.executeFetchRequest(request) as? [SpecialTestManagedObject] {
			print("MANAGED SPECIAL TESTS:")
			for managedSpecialLink in allManagedSpecialLinks {
				print("\t\(managedSpecialLink)")
			}
		}
		print("")
	}
	
	func printVideoLinks() {
		let request = NSFetchRequest(entityName: VideoLinkManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: VideoLinkManagedObject.propertyKeys.id, ascending: true)]
		if let allManagedVideoLinks = try! self.managedObjectContext.executeFetchRequest(request) as? [VideoLinkManagedObject] {
			print("MANAGED VIDEO LINKS:")
			for managedVideoLink in allManagedVideoLinks {
				print("\t\(managedVideoLink)")
			}
		}
		print("")
	}
	
	func printAll() {
		self.printSystems()
		self.printComponents()
		self.printSpecialTests()
		self.printVideoLinks()
	}
	
}

// MARK: - Datastore Manager Protocol

@objc protocol DatastoreManagerDelegate {
	optional func didBeginStoring()
	optional func didFinishStoring()
}