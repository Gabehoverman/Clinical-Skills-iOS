//
//  ExamTechnique.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class ExamTechnique {
	
	var system: System
	var id: Int32
	var name: String
	var details: String
	
	init(system: System, id: Int32, name: String, details: String) {
		self.system = system
		self.id = id
		self.name = name
		self.details = details
	}
	
	init(managedObject: ExamTechniqueManagedObject) {
		self.system = System(managedObject: managedObject.system)
		self.id = managedObject.id
		self.name = managedObject.name
		self.details = managedObject.details
	}
	
}

func ==(lhs: ExamTechnique, rhs: ExamTechnique) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: ExamTechnique, rhs: ExamTechnique) -> Bool {
	return !(lhs == rhs)
}