//
//  UserDefaultsManager.swift
//  WVU Clinical Skills
//
//  Created by Nick on 1/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class UserDefaultsManager {
	
	static let userDefaults = UserDefaults.standard
	
	struct userDefaultsKeys {
		static let requestFromLocalHost = "requestFromLocalHost"
	}
	
	static let userDefaultsKeysList = [
		userDefaultsKeys.requestFromLocalHost,
	]
	
	static func titleFromKey(_ key: String) -> String {
		let splitRegex = try! NSRegularExpression(pattern: "([a-z])([A-Z])", options: .allowCommentsAndWhitespace)
		let splitString = splitRegex.stringByReplacingMatches(in: key, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: key.characters.count), withTemplate: "$1 $2")
		return splitString.capitalized
	}
	
	static func loadFromSettingsBundle() {
		if let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle") {
			if let settings = NSDictionary(contentsOfFile: NSString(string: settingsBundle).appendingPathComponent("Root.plist")) {
				if let preferences: [NSDictionary] = settings.object(forKey: "PreferenceSpecifiers") as? [NSDictionary] {
					var defaultsToRegister = [String : AnyObject]()
					for preferenceSpecifier in preferences {
						if let key = preferenceSpecifier.object(forKey: "Key") as? String {
							defaultsToRegister[key] = preferenceSpecifier.object(forKey: "DefaultValue")! as AnyObject?
						}
					}
					UserDefaults.standard.register(defaults: defaultsToRegister)
				} else {
					print("Error reading Preferences")
				}
			} else {
				print("Error reading Root.plist")
			}
		} else {
			print("Error reading Settings.bundle")
		}
	}
	
	static func printUserDefaults() {
		for key in userDefaultsKeysList {
			if let value = userDefaults.object(forKey: key) {
				print("\(key) -> \(value)")
			}
		}
	}
	
}
