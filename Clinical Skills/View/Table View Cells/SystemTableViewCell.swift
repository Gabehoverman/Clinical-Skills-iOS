//
//  SystemTableViewCell.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

/**
	Prototype Cell for a System
*/
class SystemTableViewCell: UITableViewCell {
	
	static let systemCellIdentifier = "SystemCell"
	static let subsystemCellIdentifier = "SubsystemCell"
	
	@IBOutlet weak var systemNameLabel: UILabel!
	
}