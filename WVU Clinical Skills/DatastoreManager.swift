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
	
	override init() {
		self.delegate = nil
		super.init()
	}
	
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
		self.delegate?.didFinishStoring?()
	}
	
	func storeSubsystems(subsystems: [System]) {
		self.delegate?.didBeginStoring?()
		for subsystem in subsystems {
			self.storeSubsystem(subsystem)
		}
		self.delegate?.didFinishStoring?()
	}
	
	func storeSystem(system: System) {
		if !self.containsSystemWithName(system.name) {
			let entity = NSEntityDescription.entityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SystemManagedObject {
				newManagedSystem.name = system.name
				newManagedSystem.details = system.details
				newManagedSystem.visible = system.visible
				newManagedSystem.links = self.storeLinks(system.links, forManagedSystem: newManagedSystem)
			}
		}
	}
	
	func storeSubsystem(subsystem: System) {
		if !self.containsSystemWithName(subsystem.name) {
			let entity = NSEntityDescription.entityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSubsystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SystemManagedObject {
				newManagedSubsystem.name = subsystem.name
				newManagedSubsystem.details = subsystem.details
				newManagedSubsystem.visible = subsystem.visible
				newManagedSubsystem.links = self.storeLinks(subsystem.links, forManagedSystem: newManagedSubsystem)
				newManagedSubsystem.parentSystem = self.retrieveSystemWithName(subsystem.parentName)
				newManagedSubsystem.parentSystem?.addSubsystem(newManagedSubsystem)
			}
		}
	}
	
	func storeLinks(links: NSMutableSet, forManagedSystem: SystemManagedObject) -> NSMutableSet {
		let storedLinks = NSMutableSet()
		for link in links {
			if let link = link as? Link {
				if self.containsLinkWithTitle(link.title) {
					if let managedLink = self.retrieveLinkWithTitle(link.title) {
						managedLink.addSystem(forManagedSystem)
						forManagedSystem.addLink(managedLink)
					}
				} else {
					let entity = NSEntityDescription.entityForName(ManagedObjectEntityNames.Link.rawValue, inManagedObjectContext: self.managedObjectContext)!
					if let newManagedLink = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? LinkManagedObject {
						newManagedLink.title = link.title
						newManagedLink.link = link.link
						newManagedLink.visible = link.visible
						newManagedLink.addSystem(forManagedSystem)
						forManagedSystem.addLink(newManagedLink)
						storedLinks.addObject(newManagedLink)
					}
				}
			}
		}
		return storedLinks
	}
	
	// MARK: - Retrieve Methods
	
	func retrieveSystemWithName(name: String?) -> SystemManagedObject? {
		guard let name = name else {
			return nil
		}
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.System.Name.rawValue, name)
		if let managedSystem = try! self.managedObjectContext.executeFetchRequest(request).first as? SystemManagedObject {
			return managedSystem
		}
		return nil
	}
	
	func retrieveSubsystemWithName(name: String?) -> SystemManagedObject? {
		guard let name = name else {
			return nil
		}
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue, name)
		if let managedSystem = try! self.managedObjectContext.executeFetchRequest(request).first as? SystemManagedObject {
			return managedSystem
		}
		return nil
	}
	
	func retrieveLinkWithTitle(title: String?) -> LinkManagedObject? {
		guard let title = title else {
			return nil
		}
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Link.Title.rawValue, title)
		if let managedLink = try! self.managedObjectContext.executeFetchRequest(request).first as? LinkManagedObject {
			return managedLink
		}
		return nil
	}
	
	// MARK: - Utility Methods
	
	func containsSystemWithName(name: String) -> Bool {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.System.Name.rawValue, name)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsLinkWithTitle(title: String) -> Bool {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Link.Title.rawValue, title)
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
	
	// MARK: - Printing Methods
	
	func printContents() {
		self.printSystems()
		self.printSubsystems()
		self.printLinks()
	}
	
	func printSystems() {
		
	}
	
	func printSubsystems() {
		
	}
	
	func printLinks() {
		
	}
	
}