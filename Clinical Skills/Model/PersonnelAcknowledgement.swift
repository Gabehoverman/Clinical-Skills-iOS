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
	
	struct propertyKeys {
		static let type = "personnel"
		static let name = "name"
		static let role = "role"
		static let notes = "notes"
	}
	
	var name: String
	var role: String
	var notes: String
	override var description: String {
		get {
			return "Personnel: \(self.name), \(self.role), \(self.notes)"
		}
	}
	
	override init() {
		self.name = "Name"
		self.role = "Role"
		self.notes = "Notes"
	}
	
	convenience init(name: String, role: String, notes: String) {
		self.init()
		self.name = name
		self.role = role
		self.notes = notes
	}
	
	convenience init(json: JSON) {
		self.init()
		for (key, value) in json {
			if (key == PersonnelAcknowledgement.propertyKeys.name) {
				self.name = value.stringValue
			}
			if (key == PersonnelAcknowledgement.propertyKeys.role) {
				self.role = value.stringValue
			}
			if (key == PersonnelAcknowledgement.propertyKeys.notes) {
				self.notes = value.stringValue
			}
		}
	}
}