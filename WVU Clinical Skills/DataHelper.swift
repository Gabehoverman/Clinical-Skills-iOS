//
//  DataHelper.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

/**
	Utility for Seeding and Displaying the Database
*/
class DataHelper: NSObject {

	let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	/**
		Inserts System seed data into the database
	*/
	func seedSystems() {
		
		let systems = [
			(name: "Musculoskeletal", description: "This system includes anything relating to the muscles or skeleton", visible: false),
			(name: "Cardiovascular", description: "This system includes anything relating to the heart, veins, and arteries", visible: true),
			(name: "Ear, Nose, and Throat", description: "This system includes anything relating to the ears, nose, or throat", visible: false),
			(name: "Respiratory", description: "This system includes anything relating to the lungs and respiration", visible: true),
			(name: "Neurological", description: "This system includes anything relating to the brain", visible: false),
			(name: "Abdomen", description: "This system includes anything relating to the abdominal region", visible: true)
		]
		
		for system in systems {
			let newSystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
			newSystem.systemName = system.name
			newSystem.systemDescription = system.description
			newSystem.visible = system.visible
		}
		
		do {
			try self.context.save()
		} catch _ {
			// Silently Ignore Error
		}
		
	}
	
	/**
		Prints all System data currently in the database
	*/
	func printAllSystems() {
		
		let systemFetchRequest = NSFetchRequest(entityName: "System")
		let allSystems = (try! context.executeFetchRequest(systemFetchRequest)) as! [System]
		print("SYSTEMS")
		for system in allSystems {
			print("\t\(system.toString())")
		}
		
	}
	
}
