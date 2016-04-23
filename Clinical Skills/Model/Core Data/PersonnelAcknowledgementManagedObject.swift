//
//  PersonnelAcknowledgementManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 4/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(PersonnelAcknowledgementManagedObject)
class PersonnelAcknowledgementManagedObject: NSManagedObject {
	
	static let entityName = "PersonnelAcknowledgement"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
		static let role = "role"
		static let notes = "notes"
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var role : String
	@NSManaged var notes: String
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
}

func ==(lhs: PersonnelAcknowledgementManagedObject, rhs: PersonnelAcknowledgementManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: PersonnelAcknowledgementManagedObject, rhs: PersonnelAcknowledgementManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: PersonnelAcknowledgementManagedObject, rhs: PersonnelAcknowledgement) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: PersonnelAcknowledgementManagedObject, rhs: PersonnelAcknowledgement) -> Bool {
	return !(lhs == rhs)
}