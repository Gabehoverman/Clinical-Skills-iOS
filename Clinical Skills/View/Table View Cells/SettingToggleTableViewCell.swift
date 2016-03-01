//
//  SettingToggleTableViewCell.swift
//  WVU Clinical Skills
//
//  Created by Nick on 1/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class SettingToggleTableViewCell: UITableViewCell {
	
	static let settingToggleCellIdentifier = "SettingToggleCell"
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var toggleSwitch: UISwitch!
	
}