//
//  PersonnelAcknowledgement.swift
//  Clinical Skills
//
//  Created by Nick on 4/22/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import SwiftyJSON

class PersonnelAcknowledgement: NSObject {
	
	var id: Int32
	var name: String
	var role: String
	var notes: String
	
	init(id: Int32, name: String, role: String, notes: String) {
		self.id = id
		self.name = name
		self.role = role
		self.notes = notes
	}
	
	init(managedObject: PersonnelAcknowledgementManagedObject) {
		self.id = managedObject.id
		self.name = managedObject.name
		self.role = managedObject.role
		self.notes = managedObject.notes
	}
}