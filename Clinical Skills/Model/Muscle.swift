//
//  Muscle.swift
//  Clinical Skills
//
//  Created by Nick on 3/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class Muscle {
	
	var component: Component
	var id: Int32
	var name: String
	
	init(component: Component, id: Int32, name: String) {
		self.component = component
		self.id = id
		self.name = name
	}
	
	init(managedObject: MuscleManagedObject) {
		self.component = Component(managedObject: managedObject.component)
		self.id = managedObject.id
		self.name = managedObject.name
	}
	
}

func ==(lhs: Muscle, rhs: Muscle) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: Muscle, rhs: Muscle) -> Bool {
	return !(lhs == rhs)
}