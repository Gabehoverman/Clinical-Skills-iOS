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
	
	func storeSubsystems(subsystems: [System]) {
		self.delegate?.didBeginStoring?()
		for subsystem in subsystems {
			self.storeSubsystem(subsystem)
		}
		self.save()
		self.delegate?.didFinishStoring?()
	}
	
	func storeSystem(system: System) {
		let existingManagedSystem = self.retrieveSystemWithName(system.name)
		if existingManagedSystem == nil {
			let entity = NSEntityDescription.entityForName(SystemManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
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
			let entity = NSEntityDescription.entityForName(SystemManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
			if let newManagedSubsystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? SystemManagedObject {
				newManagedSubsystem.name = subsystem.name
				newManagedSubsystem.details = subsystem.details
				newManagedSubsystem.visible = subsystem.visible
				newManagedSubsystem.parentSystem = self.retrieveSystemWithName(subsystem.parentName)
				newManagedSubsystem.parentSystem?.addSubsystem(newManagedSubsystem)
				newManagedSubsystem.links = self.storeLinks(subsystem.links, forManagedSystem: newManagedSubsystem)
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
						storedLinks.addObject(managedLink)
					}
				} else {
					let entity = NSEntityDescription.entityForName(LinkManagedObject.entityName, inManagedObjectContext: self.managedObjectContext)!
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
	
	func updateLinksForNewSystem(newManagedSystem: SystemManagedObject, fromManagedSystem: SystemManagedObject) -> NSMutableSet {
		let newManagedLinks = NSMutableSet()
		let request = NSFetchRequest(entityName: LinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", LinkManagedObject.propertyKeys.systems, fromManagedSystem)
		if let allManagedLinks = try! self.managedObjectContext.executeFetchRequest(request) as? [LinkManagedObject] {
			for managedLink in allManagedLinks {
				managedLink.systems.removeObject(fromManagedSystem)
				fromManagedSystem.links.removeObject(managedLink)
				managedLink.systems.addObject(newManagedSystem)
				newManagedSystem.links.addObject(managedLink)
				newManagedLinks.addObject(managedLink)
			}
		}
		return newManagedLinks
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
	
	func retrieveSubsystemWithName(name: String?) -> SystemManagedObject? {
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
	
	func retrieveLinkWithTitle(title: String?) -> LinkManagedObject? {
		guard let title = title else {
			return nil
		}
		let request = NSFetchRequest(entityName: LinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %@", LinkManagedObject.propertyKeys.title, title)
		if let managedLink = try! self.managedObjectContext.executeFetchRequest(request).first as? LinkManagedObject {
			return managedLink
		}
		return nil
	}
	
	// MARK: - Utility Methods
	
	func containsSystemWithName(name: String) -> Bool {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %@", SystemManagedObject.propertyKeys.name, name)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		return results.count != 0
	}
	
	func containsLinkWithTitle(title: String) -> Bool {
		let request = NSFetchRequest(entityName: LinkManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = %@", LinkManagedObject.propertyKeys.title, title)
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
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K = nil", SystemManagedObject.propertyKeys.parent)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.visible, ascending: false)]
		request.sortDescriptors!.append(NSSortDescriptor(key: SystemManagedObject.propertyKeys.name, ascending: true))
		if let allManagedSystems = try! self.managedObjectContext.executeFetchRequest(request) as? [SystemManagedObject] {
			print("MANAGED SYSTEMS:")
			for managedSystem in allManagedSystems {
				print("\t\(managedSystem)")
			}
		}
		print("")
	}
	
	func printSubsystems() {
		let request = NSFetchRequest(entityName: SystemManagedObject.entityName)
		request.predicate = NSPredicate(format: "%K != nil", SystemManagedObject.propertyKeys.parent)
		request.sortDescriptors = [NSSortDescriptor(key: SystemManagedObject.propertyKeys.visible, ascending: false)]
		request.sortDescriptors!.append(NSSortDescriptor(key: SystemManagedObject.propertyKeys.name, ascending: true))
		if let allManagedSubsystems = try! self.managedObjectContext.executeFetchRequest(request) as? [SystemManagedObject] {
			print("MANAGED SUBSYSTEMS:")
			for managedSubsystem in allManagedSubsystems {
				print("\t\(managedSubsystem)")
			}
		}
		print("")
	}
	
	func printLinks() {
		let request = NSFetchRequest(entityName: LinkManagedObject.entityName)
		request.sortDescriptors = [NSSortDescriptor(key: LinkManagedObject.propertyKeys.visible, ascending: false)]
		request.sortDescriptors!.append(NSSortDescriptor(key: LinkManagedObject.propertyKeys.title, ascending: true))
		if let allManagedLinks = try! self.managedObjectContext.executeFetchRequest(request) as? [LinkManagedObject] {
			print("MANAGED LINKS:")
			for managedLink in allManagedLinks {
				print("\t\(managedLink) + \(managedLink.systems.count)")
				for system in managedLink.systems {
					let system = system as! SystemManagedObject
					print("\t\t\(system.name)")
				}
			}
		}
		print("")
	}
	
}