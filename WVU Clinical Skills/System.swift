//
//  System.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData


@objc(System)
class System: NSManagedObject {
	
	@NSManaged var systemName: String
	@NSManaged var systemDescription : String
	
}