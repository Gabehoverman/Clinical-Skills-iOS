//
//  ExamTechniqueManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(ExamTechniqueManagedObject)
class ExamTechniqueManagedObject : NSManagedObject {
	
	static let entityName = "ExamTechnique"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
		static let details = "details"
	}
	
	@NSManaged var system: SystemManagedObject
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var details: String
	
	override var description: String {
		get {
			return "ID: \(self.id) \(self.name)"
		}
	}
	
}

func ==(lhs: ExamTechniqueManagedObject, rhs: ExamTechniqueManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: ExamTechniqueManagedObject, rhs: ExamTechniqueManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: ExamTechniqueManagedObject, rhs: ExamTechnique) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: ExamTechniqueManagedObject, rhs: ExamTechnique) -> Bool {
	return !(lhs == rhs)
}