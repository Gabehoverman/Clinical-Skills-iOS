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
	
	func storeSystemFromDictionary(dictionary: [String : AnyObject]) -> Bool {
		var stored = false
		if self.containsSystemWithName(dictionary[ManagedObjectEntityPropertyKeys.System.Name.rawValue] as! String) {
			let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
			request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.System.Name.rawValue, dictionary[ManagedObjectEntityPropertyKeys.System.Name.rawValue] as! String)
			if let system = try! self.managedObjectContext.executeFetchRequest(request).first as? System {
				system.systemName = dictionary[ManagedObjectEntityPropertyKeys.System.Name.rawValue] as! String
				system.systemDescription = dictionary[ManagedObjectEntityPropertyKeys.System.Description.rawValue] as! String
				system.visible = dictionary[ManagedObjectEntityPropertyKeys.System.Visible.rawValue] as! Bool
				self.storeLinksFromDictionaries(dictionary[ManagedObjectEntityPropertyKeys.System.Links.rawValue] as! [[String : AnyObject]], forSystem: system)
			}
		} else {
			let entity = NSEntityDescription.entityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.managedObjectContext)!
			if let newSystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? System {
				newSystem.systemName = dictionary[ManagedObjectEntityPropertyKeys.System.Name.rawValue] as! String
				newSystem.systemDescription = dictionary[ManagedObjectEntityPropertyKeys.System.Description.rawValue] as! String
				newSystem.visible = dictionary[ManagedObjectEntityPropertyKeys.System.Visible.rawValue] as! Bool
				self.storeLinksFromDictionaries(dictionary[ManagedObjectEntityPropertyKeys.System.Links.rawValue] as! [[String : AnyObject]], forSystem: newSystem)
				stored = true
			}
		}
		return stored
	}
	
	func storeSubsystemFromDictionary(dictionary: [String : AnyObject]) -> Bool {
		var stored = false
		if !self.containsSystemWithName(dictionary[ManagedObjectEntityPropertyKeys.System.Name.rawValue] as! String) {
			let entity = NSEntityDescription.entityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.managedObjectContext)!
			if let newSubsystem = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? System {
				newSubsystem.systemName = dictionary[ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue] as! String
				newSubsystem.systemDescription = dictionary[ManagedObjectEntityPropertyKeys.Subsystem.Description.rawValue] as! String
				newSubsystem.visible = dictionary[ManagedObjectEntityPropertyKeys.Subsystem.Visible.rawValue] as! Bool
				if let parent = self.retrieveParentSystemFromName(dictionary[ManagedObjectEntityPropertyKeys.Subsystem.ParentName.rawValue] as! String) {
					newSubsystem.parentSystem = parent
					parent.addSubsystem(newSubsystem)
				}
				self.storeLinksFromDictionaries(dictionary[ManagedObjectEntityPropertyKeys.System.Links.rawValue] as! [[String : AnyObject]], forSystem: newSubsystem)
				stored = true
			}
		}
		return stored
	}
	
	func storeLinksFromDictionaries(dictionaries: [[String : AnyObject]], forSystem: System) {
		for linkDict in dictionaries {
			if containsLinkWithTitle(linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue] as! String) {
				let request = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
				request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Link.Title.rawValue, linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue] as! String)
				if let link = try! self.managedObjectContext.executeFetchRequest(request).first as? Link {
					let request = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
					var predicates = [NSPredicate]()
					predicates.append(NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.Link.Title.rawValue, link.title))
					predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", ManagedObjectEntityPropertyKeys.Link.Systems.rawValue, forSystem))
					request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
					if let results = try! self.managedObjectContext.executeFetchRequest(request) as? [Link] {
						if results.count == 0 {
							link.addSystem(forSystem)
							forSystem.addLink(link)
						}
					}
				}
			} else {
				let entity = NSEntityDescription.entityForName(ManagedObjectEntityNames.Link.rawValue, inManagedObjectContext: self.managedObjectContext)!
				if let link = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext) as? Link {
					link.title = linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue] as! String
					link.link = linkDict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue] as! String
					link.visible = linkDict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue] as! Bool
					link.addSystem(forSystem)
					forSystem.addLink(link)
				}
			}
		}
	}
	
	// MARK: - Retrieve Methods
	
	func retrieveParentSystemFromName(name: String) -> System? {
		let request = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
		request.predicate = NSPredicate(format: "%K = %@", ManagedObjectEntityPropertyKeys.System.Name.rawValue, name)
		let results = try! self.managedObjectContext.executeFetchRequest(request)
		if let parent = results.first as? System {
			return parent
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
	
	func addLinkToSystem(link: Link, system: System) {
		
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
			print("Saved Managed Object Context")
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