//
//  RangeOfMotion.swift
//  Clinical Skills
//
//  Created by Nick Alexander on 3/25/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class RangeOfMotion {
	
	var component: Component
	var id: Int32
	var motion: String
	var degrees: String
	var notes: String
	
	init(component: Component, id: Int32, motion: String, degrees: String, notes: String) {
		self.component = component
		self.id = id
		self.motion = motion
		self.degrees = degrees
		self.notes = notes
	}
	
	init(managedObject: RangeOfMotionManagedObject) {
		self.component = Component(managedObject: managedObject.component)
		self.id = managedObject.id
		self.motion = managedObject.motion
		self.degrees = managedObject.degrees
		self.notes = managedObject.notes
	}
	
}

func ==(lhs: RangeOfMotion, rhs: RangeOfMotion) -> Bool {
	return (lhs.id == rhs.id) && (lhs.motion == rhs.motion)
}

func !=(lhs: RangeOfMotion, rhs: RangeOfMotion) -> Bool {
	return !(lhs == rhs)
}