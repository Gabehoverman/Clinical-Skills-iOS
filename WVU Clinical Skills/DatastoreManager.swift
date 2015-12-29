//
//  DatastoreManager.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import CoreData

class DatastoreManager : NSObject {
	
	// MARK: - Properties
	
	let managedObjectContext: NSManagedObjectContext
	let delegate: DatastoreManagerDelegate?
	
	// MARK: - Initializers
	
	init(managedObjectContext: NSManagedObjectContext, delegate: DatastoreManagerDelegate?) {
		self.managedObjectContext = managedObjectContext
		self.delegate = delegate
	}
	
	// MARK: - Store Methods
	
	func storeSystem(system: System) {
		
	}
	
	func storeSubsystem(subsystem: System, parent: System) {
		
	}
	
	func storeLink(link: Link) {
		
	}
	
	// MARK: - Retrieve Methods
	
	func retrieveSystems() {
		
	}
	
	func retrieveSubsystems() {
		
	}
	
	func retrieveLinks() {
		
	}
	
	// MARK: - Utility Methods
	
	func save() {
		do {
			try self.managedObjectContext.save()
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