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
	
	class func examTechniqueFromManagedObject(managedObject: ExamTechniqueManagedObject) -> ExamTechnique {
		let system = System.systemFromManagedObject(managedObject.system)
		let id = managedObject.id
		let name = managedObject.name
		let details = managedObject.details
		return ExamTechnique(system: system, id: id, name: name, details: details)
	}
	
}