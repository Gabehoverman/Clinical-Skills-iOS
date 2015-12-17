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
			(name: "Ear, Nose, and Throat", description: "This system includes anything relating to the ears, nose, or throat", visible: true),
			(name: "Respiratory", description: "This system includes anything relating to the lungs and respiration", visible: true),
			(name: "Neurological", description: "This system includes anything relating to the brain", visible: false),
			(name: "Abdomen", description: "This system includes anything relating to the abdominal region\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThis is a string with a really long gap in between!", visible: true)
		]
		
		for system in systems {
			let duplicateCheckRequest = NSFetchRequest(entityName: "System")
			duplicateCheckRequest.predicate = NSPredicate(format: "systemName = %@", system.name)
			let results = try! self.context.executeFetchRequest(duplicateCheckRequest)
			if results.count == 0 {
				let newSystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
				newSystem.systemName = system.name
				newSystem.systemDescription = system.description
				newSystem.visible = system.visible
				newSystem.parentSystem = nil
				newSystem.subsystems = nil
			}
		}
		
		self.saveContext()
	}
	
	/**
		Inserts Subsystems seed data into the database
	*/
	func seedSubsystems() {
		
		let data = [
			("Ear, Nose, and Throat", [
				(name: "Ear", description: "This system includes anything relating to the ears", visible: true),
				(name: "Nose", description: "This system includes anything relating to the nose", visible: true),
				(name: "Throat", description: "This system includes anything relating to the throat", visible: true)
			]),
			
			("Throat", [
				(name: "Left Tonsil", description: "Mass of lymphoid tissue in the back of the throat on the left side", visible: true),
				(name: "Right Tonsil", description: "Mass of lymphoid tissue in the back of the throat on the right side", visible: true)
			]),
			
			("Left Tonsil", [
				(name: "Adenoids", description: "Incompletely encapsulated by the left tonsil", visible: false),
				(name: "Tubal", description: "Located on the roof of the pharynx", visible: true),
				(name: "Palatine", description: "Incomletely encapsulated by the left tonsil", visible: false),
				(name: "Lingual", description: "Incompletely encapsulated by the left tonsil", visible: false),
			]),
			
			("Musculoskeletal", [
				(name: "Spine", description: "The verterbral column", visible: true),
				(name: "Upper Extremity", description: "The region stretching from the deltoid to the hand", visible: true),
				(name: "Lower Extremity", description: "The region between the hip and the ankle", visible: true)
			])
		]
		
		for (parentName, subsystems) in data {
			let request = NSFetchRequest(entityName: "System")
			request.predicate = NSPredicate(format: "systemName = %@", parentName)
			let parent = try! self.context.executeFetchRequest(request).first as! System
			for subsystem in subsystems {
				let duplicateCheckRequest = NSFetchRequest(entityName: "System")
				duplicateCheckRequest.predicate = NSPredicate(format: "systemName = %@", subsystem.name)
				let results = try! self.context.executeFetchRequest(duplicateCheckRequest)
				if results.count == 0 {
					let newSubsystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
					newSubsystem.systemName = subsystem.name
					newSubsystem.systemDescription = subsystem.description
					newSubsystem.visible = subsystem.visible
					newSubsystem.parentSystem = parent
					parent.addSubsystem(newSubsystem)
				}
			}
			self.saveContext()
		}
	}
	
	/**
		Saves the Managed Context with error handling
	*/
	func saveContext() {
		do {
			try self.context.save()
		} catch {
			print("Error saving the context")
		}
	}
	
	/**
		Prints the entire contents of the database with sections separated by a newline
	*/
	func printContents() {
		self.printAllSystems()
		print("")
		self.printAllSubsystems()
	}
	
	/**
		Prints all System data currently in the database
	*/
	func printAllSystems() {
		let systemFetchRequest = NSFetchRequest(entityName: "System")
		systemFetchRequest.predicate = NSPredicate(format: "parentSystem = nil")
		systemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
		let allSystems = (try! self.context.executeFetchRequest(systemFetchRequest)) as! [System]
		print("SYSTEMS")
		for system in allSystems {
			print("\t\(system.toString())")
		}
	}
	
	/**
		Prints all Subsystem data currently in the database
	*/
	func printAllSubsystems() {
		let subsystemFetchRequest = NSFetchRequest(entityName: "System")
		subsystemFetchRequest.predicate = NSPredicate(format: "parentSystem != nil")
		subsystemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
		let allSubsystems = (try! self.context.executeFetchRequest(subsystemFetchRequest)) as! [System]
		print("SUBSYSTEMS")
		for subsystem in allSubsystems {
			print("\t\(subsystem.parentSystem!.systemName) -> \(subsystem.toString())")
		}
	}
	
}
