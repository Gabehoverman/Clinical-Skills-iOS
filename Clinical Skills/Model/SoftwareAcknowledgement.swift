//
//  SoftwareAcknowledgement.swift
//  Clinical Skills
//
//  Created by Nick on 4/22/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import SwiftyJSON

class SoftwareAcknowledgement: NSObject {
	
	var id: Int32
	var name: String
	var link: String
	
	init(id: Int32, name: String, link: String) {
		self.id = id
		self.name = name
		self.link = link
	}
	
	init(managedObject: SoftwareAcknowledgementManagedObject) {
		self.id = managedObject.id
		self.name = managedObject.name
		self.link = managedObject.link
	}
	
}