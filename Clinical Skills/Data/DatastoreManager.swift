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

@objc protocol DatastoreManagerDelegate {
	optional func didBeginStoring()
	optional func didFinishStoring()
}

class DatastoreManager : NSObject {
	
	// MARK: - Properties
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	let delegate: DatastoreManagerDelegate?
	
	// MARK: - Initializers
	
	init(delegate: DatastoreManagerDelegate?) {
		self.delegate = delegate
		super.init()
	}
	
	// MARK: - Store Methods
	
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
	
	func storeSystem(system: System) {
		let existingManagedSystem = self.retrieveSystemWithName(system.name)
		if existingManagedSystem == nil {
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
				
				let systemRequest = NSFetchRequest(entityName: SystemManagedObject.entityName)
				systemRequest.predicate = NSPredicate(format: "%K = %d", SystemManagedObject.propertyKeys.id, component.parent.id)
				
				if let managedSystem = try! self.managedObjectContext.executeFetchRequest(systemRequest).first as? SystemManagedObject {
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
				
				let componentRequest = NSFetchRequest(entityName: ComponentManagedObject.entityName)
				componentRequest.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, specialTest.component.id)
				if let managedComponent = try! self.managedObjectContext.executeFetchRequest(componentRequest).first as? ComponentManagedObject {
					newManagedSpecialTest.component = managedComponent
				}
			}
		}
	}
	
	// MARK: - Retrieve Methods
	
	func retrieveSystemWithName(name: String?) -> SystemManagedObject? {
		guard let name = name else {
			return nil
		}
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %@", SystemManagedObject.propertyKeys.name, name)
		if let managedSystem = try! self.managedObjectContext.executeFetchRequest(request).first as? SystemManagedObject {
			return managedSystem
		}
		return nil
	}
	
	// MARK: - Utility Methods
	
	func containsSystemWithID(id: Int) -> Bool {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %@", SystemManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsComponentWithID(id: Int) -> Bool {
		let request = NSFetchRequest(entityName: ComponentManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsSpecialTestWithID(id: Int) -> Bool {
		let request = NSFetchRequest(entityName: SpecialTestManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %d", ComponentManagedObject.propertyKeys.id, id)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
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
	
	func clearSystems() {
		do {
			let allSystemsRequest = NSFetchRequest(entityName: SystemManagedObject.entityName)
			var allSystems = try self.managedObjectContext.executeFetchRequest(allSystemsRequest)
			print("\(allSystems.count) Objects to be Deleted")
			for system in allSystems {
				self.managedObjectContext.deleteObject(system as! NSManagedObject)
			}
			allSystems.removeAll(keepCapacity: false)
			print("Saving Managed Object Context\n")
			try self.managedObjectContext.save()
		} catch {
			print("Error Clearing Systems")
			print("\(error)")
		}
	}
	
	func clearComponents() {
		do {
			let allComponentsRequest = NSFetchRequest(entityName: ComponentManagedObject.entityName)
			var allComponents = try self.managedObjectContext.executeFetchRequest(allComponentsRequest)
			print("\(allComponents.count) Objects to be Deleted")
			for component in allComponents {
				self.managedObjectContext.deleteObject(component as! NSManagedObject)
			}
			allComponents.removeAll(keepCapacity: false)
			print("Saving Managed Object Context")
			try self.managedObjectContext.save()
		} catch {
			print("Error Clearing Components")
			print("\(error)")
		}
	}
	
	func clearAll() {
		for entityName in [SystemManagedObject.entityName, ComponentManagedObject.entityName] {
			do {
				let request = NSFetchRequest(entityName: entityName)
				var allObjects = try self.managedObjectContext.executeFetchRequest(request)
				print("\(allObjects.count) Objects to be Deleted")
				for object in allObjects {
					self.managedObjectContext.deleteObject(object as! NSManagedObject)
				}
				allObjects.removeAll(keepCapacity: false)
				print("Saving Managed Object Context\n")
				try self.managedObjectContext.save()
			} catch {
				print("Error Clearing All")
				print("\(error)")
			}
		}
	}
	
	// MARK: - Printing Methods
	
	func printContents() {
		self.printSystems()
		self.printComponents()
	}
	
	func printSystems() {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.sortDescriptors!.append(NSSortDescriptor(key: SystemManagedObject.propertyKeys.name, ascending: true))
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
		if let allManagedComponents = try! self.managedObjectContext.executeFetchRequest(request) as? [ComponentManagedObject] {
			print("MANAGED COMPONENTS:")
			for managedComponent in allManagedComponents {
				print("\t\(managedComponent)")
			}
		}
	}
	
}