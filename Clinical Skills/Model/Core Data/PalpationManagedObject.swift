//
//  PalpationManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 3/31/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(PalpationManagedObject)
class PalpationManagedObject : NSManagedObject {
	
	static let entityName = "Palpation"
	struct propertyKeys {
		static let id = "id"
		static let structure = "structure"
		static let details = "details"
		static let notes = "notes"
	}
	
	@NSManaged var component: ComponentManagedObject
	@NSManaged var id: Int32
	@NSManaged var structure: String
	@NSManaged var details: String
	@NSManaged var notes: String
	
	override var description: String {
		get {
			return "ID: \(self.id) \(self.structure)"
		}
	}
	
}

func ==(lhs: PalpationManagedObject, rhs: PalpationManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.structure == rhs.structure)
}

func !=(lhs: PalpationManagedObject, rhs: PalpationManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: PalpationManagedObject, rhs: Palpation) -> Bool {
	return (lhs.id == rhs.id) && (lhs.structure == rhs.structure)
}

func !=(lhs: PalpationManagedObject, rhs: Palpation) -> Bool {
	return !(lhs == rhs)
}