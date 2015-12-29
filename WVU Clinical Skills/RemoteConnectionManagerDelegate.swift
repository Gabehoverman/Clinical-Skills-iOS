//
//  RemoteConnectionManagerDelegate.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

@objc protocol RemoteConnectionManagerDelegate {
	optional func didBeginDataRequest()
	optional func didFinishDataRequest()
	optional func didFinishDataRequestWithData(receivedData: NSData)
}