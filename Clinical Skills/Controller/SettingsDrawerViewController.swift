//
//  SettingsDrawerViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 1/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class SettingsDrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	// MARK: - Class Constants
	static let storyboardIdentifier = "SettingsDrawerViewController"
	
	// MARK: - Table View Methods
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return UserDefaultsManager.userDefaultsKeysList.count
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Settings"
		}
		return "Section \(section)"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let key = UserDefaultsManager.userDefaultsKeysList[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(SettingToggleTableViewCell.settingToggleCellIdentifier) as! SettingToggleTableViewCell
		cell.titleLabel.text = UserDefaultsManager.titleFromKey(key)
		cell.toggleSwitch.setOn(UserDefaultsManager.userDefaults.boolForKey(key), animated: false)
		cell.toggleSwitch.tag = indexPath.row
		cell.toggleSwitch.addTarget(self, action: "toggleSwitchControl:", forControlEvents: .ValueChanged)
		return cell
	}
	
	// MARK: - Utility Methods
	
	func toggleSwitchControl(switchControl: UISwitch) {
		UserDefaultsManager.userDefaults.setBool(switchControl.on, forKey: UserDefaultsManager.userDefaultsKeysList[switchControl.tag])
		NSNotificationCenter.defaultCenter().postNotificationName(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost, object: switchControl.on)
	}
	
}