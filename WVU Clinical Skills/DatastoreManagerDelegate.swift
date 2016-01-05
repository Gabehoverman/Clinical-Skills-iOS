//
//  DatastoreManagerProtocol.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

@objc protocol DatastoreManagerDelegate {
	optional func didBeginStoring()
	optional func didFinishStoring()
}