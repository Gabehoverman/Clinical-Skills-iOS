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
	
	init(managedObject: PalpationManagedObject) {
		self.component = Component(managedObject: managedObject.component)
		self.id = managedObject.id
		self.structure = managedObject.structure
		self.details = managedObject.details
		self.notes = managedObject.notes
	}
	
}

func ==(lhs: Palpation, rhs: Palpation) -> Bool {
	return (lhs.id == rhs.id) && (lhs.structure == rhs.structure)
}

func !=(lhs: Palpation, rhs: Palpation) -> Bool {
	return !(lhs == rhs)
}