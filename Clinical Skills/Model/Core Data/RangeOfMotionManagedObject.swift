//
//  RangeOfMotion.swift
//  Clinical Skills
//
//  Created by Nick Alexander on 3/25/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(RangeOfMotionManagedObject)
class RangeOfMotionManagedObject : NSManagedObject {
	
	static let entityName = "RangeOfMotion"
	struct propertyKeys {
		static let id = "id"
		static let motion = "motion"
		static let degrees = "degrees"
		static let notes = "notes"
	}
	
	@NSManaged var component: ComponentManagedObject
	@NSManaged var id: Int32
	@NSManaged var motion: String
	@NSManaged var degrees: String
	@NSManaged var notes: String
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.motion)"
		}
	}
	
}

func ==(lhs: RangeOfMotionManagedObject, rhs: RangeOfMotionManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.motion == rhs.motion)
}

func !=(lhs: RangeOfMotionManagedObject, rhs: RangeOfMotionManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: RangeOfMotionManagedObject, rhs: RangeOfMotion) -> Bool {
	return (lhs.id == rhs.id) && (lhs.motion == rhs.motion)
}

func !=(lhs: RangeOfMotionManagedObject, rhs: RangeOfMotion) -> Bool {
	return !(lhs == rhs)
}