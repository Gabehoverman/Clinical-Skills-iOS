//
//  RemoteConnectionManager.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

class RemoteConnectionManager : NSObject {
	
	// MARK: - Properties

	var statusCode: Int
	var statusMessage: String {
		get {
			if self.statusCode == 0 {
				return "No Response"
			}
			return "Status Code \(statusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode).capitalizedString)"
		}
	}
	var statusSuccess: Bool {
		get {
			return self.statusCode >= 200 && self.statusCode < 300
		}
	}
	var delegate: RemoteConnectionManagerDelegate?
	
	// MARK: - Initializers
	
	init(delegate: RemoteConnectionManagerDelegate?) {
		self.statusCode = 0
		self.delegate = delegate
	}
	
	// MARK: - Fetch Methods
	
	func fetchSystems() {
		if let remoteURL = NSURL(string: DataURLStrings.Remote.Systems.rawValue) {
			self.fetchWithURL(remoteURL)
		}
	}
	
	func fetchSubsystems() {
		if let remoteURL = NSURL(string: DataURLStrings.Remote.Subsystems.rawValue) {
			self.fetchWithURL(remoteURL)
		}
	}
	
	func fetchLinks() {
		if let remoteURL = NSURL(string: DataURLStrings.Remote.Links.rawValue) {
			self.fetchWithURL(remoteURL)
		}
	}
	
	private func fetchWithURL(url: NSURL) {
		let session = NSURLSession.sharedSession()
		session.dataTaskWithURL(url, completionHandler: {
			(receivedData: NSData?, httpResponse: NSURLResponse?, error: NSError?) -> Void in
			self.completedDataTaskReceivingData(receivedData, response: httpResponse, error: error)
		}).resume()
		self.delegate?.didBeginDataRequest?()
	}
	
	// MARK: - Utility Methods
	
	private func completedDataTaskReceivingData(data: NSData?, response: NSURLResponse?, error: NSError?) {
		if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
			self.statusCode = statusCode
		}
		
		if error != nil {
			print(self.messageForError(error!))
		}
		
		if data != nil {
			self.delegate?.didFinishDataRequestWithData?(data!)
		}
		self.delegate?.didFinishDataRequest?()
	}
	
	func messageForError(error: NSError) -> String {
		return "RemoteConnectionManager - Error fetching remote data" + "\n" + "\(error.localizedDescription)"
	}
	
}