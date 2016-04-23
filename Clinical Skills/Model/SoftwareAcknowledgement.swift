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
	
	struct propertyKeys {
		static let type = "software"
		static let name = "name"
		static let link = "link"
		static let license = "license"
	}
	
	var name: String
	var link: String
	var license: String
	override var description: String {
		get {
			return "Software: \(self.name), \(self.link)"
		}
	}
	
	override init() {
		self.name = "Name"
		self.link = "Link"
		self.license = "License"
	}
	
	convenience init(name: String, link: String, license: String) {
		self.init()
		self.name = name
		self.link = link
		self.license = license
	}
	
	convenience init(json: JSON) {
		self.init()
		for (key, value) in json {
			if (key == SoftwareAcknowledgement.propertyKeys.name) {
				self.name = value.stringValue
			}
			if (key == SoftwareAcknowledgement.propertyKeys.link) {
				self.link = value.stringValue
			}
			if (key == SoftwareAcknowledgement.propertyKeys.license) {
				self.license = value.stringValue
			}
		}
	}
}