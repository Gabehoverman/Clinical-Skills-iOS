//
//  AcknowledgementsManager.swift
//  Clinical Skills
//
//  Created by Nick on 4/22/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import SwiftyJSON

class AcknowledgementsManager {
	
	let acknowledgementFileURL = Bundle.main.url(forResource: "Acknowledgements", withExtension: "json")
	
	var personnel: [PersonnelAcknowledgement]
	var software: [SoftwareAcknowledgement]
	var acknowledgementsJSON: JSON?
	
	init() {
		self.personnel = [PersonnelAcknowledgement]()
		self.software = [SoftwareAcknowledgement]()
		if self.acknowledgementFileURL != nil {
			if let acknowledgementsData = try? Data(contentsOf: self.acknowledgementFileURL!) {
				self.acknowledgementsJSON = JSON(data: acknowledgementsData)
			}
		}
	}
	
//	func process() {
//		if self.acknowledgementsJSON != nil {
//			for (acknowledgementType, acknowledgements) in self.acknowledgementsJSON! {
//				for (_, acknowledgement) in acknowledgements {
//					if (acknowledgementType == PersonnelAcknowledgement.propertyKeys.type) {
//						self.personnel.append(PersonnelAcknowledgement(json: acknowledgement))
//					} else if (acknowledgementType == SoftwareAcknowledgement.propertyKeys.type) {
//						self.software.append(SoftwareAcknowledgement(json: acknowledgement))
//					}
//				}
//			}
//		}
//	}
	
}
