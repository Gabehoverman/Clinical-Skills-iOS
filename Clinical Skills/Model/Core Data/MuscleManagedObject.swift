//
//  MuscleManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 3/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(MuscleManagedObject)
class MuscleManagedObject : NSManagedObject {
	
	static let entityName = "Muscle"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var component: ComponentManagedObject
	
	override var description: String {
		get {
			return "ID: \(self.id) \(self.name)"
		}
	}
	
}