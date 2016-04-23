//
//  SoftwareAcknowledgementManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 4/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(SoftwareAcknowledgementManagedObject)
class SoftwareAcknowledgementManagedObject: NSManagedObject {
	
	static let entityName = "SoftwareAcknowledgement"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
		static let link = "link"
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var link : String
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
}

func ==(lhs: SoftwareAcknowledgementManagedObject, rhs: SoftwareAcknowledgementManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SoftwareAcknowledgementManagedObject, rhs: SoftwareAcknowledgementManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: SoftwareAcknowledgementManagedObject, rhs: SoftwareAcknowledgement) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SoftwareAcknowledgementManagedObject, rhs: SoftwareAcknowledgement) -> Bool {
	return !(lhs == rhs)
}