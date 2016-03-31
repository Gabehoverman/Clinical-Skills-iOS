//
//  Palpation.swift
//  Clinical Skills
//
//  Created by Nick on 3/31/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class Palpation {
	var component: Component
	var id: Int32
	var structure: String
	var details: String
	var notes: String
	
	init(component: Component, id: Int32, structure: String, details: String, notes: String) {
		self.component = component
		self.id = id
		self.structure = structure
		self.details = details
		self.notes = notes
	}
	
	class func palpationFromManagedObject(managedObject: PalpationManagedObject) -> Palpation {
		let component = Component.componentFromManagedObject(managedObject.component)
		let id = managedObject.id
		let structure = managedObject.structure
		let details = managedObject.details
		let notes = managedObject.notes
		return Palpation(component: component, id: id, structure: structure, details: details, notes: notes)
	}
}