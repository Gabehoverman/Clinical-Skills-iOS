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
	
	private var receivedData: NSMutableData
	var delegate: RemoteConnectionManagerDelegate?
	
	// MARK: - Initializers
	
	override init() {
		self.delegate = nil
		self.receivedData = NSMutableData()
	}
	
	init(delegate: RemoteConnectionManagerDelegate?) {
		self.delegate = delegate
		self.receivedData = NSMutableData()
	}
	
	// MARK: - Fetch Methods
	
	func fetchSystems() {
		if let remoteURL = NSURL(string: RemoteDataURLStrings.Systems.rawValue) {
			self.fetchWithURL(remoteURL)
		}
	}
	
	func fetchSubsystems() {
		if let remoteURL = NSURL(string: RemoteDataURLStrings.Subsystems.rawValue) {
			self.fetchWithURL(remoteURL)
		}
	}
	
	func fetchLinks() {
		if let remoteURL = NSURL(string: RemoteDataURLStrings.Links.rawValue) {
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
			print(self.messageForHTTPStatusCode(statusCode))
		}
		
		if error != nil {
			print(self.messageForError(error!))
		}
		
		if data != nil {
			self.receivedData.appendData(data!)
		}
		
		self.delegate?.didFinishDataRequestWithData?(self.receivedData)

	}
	
	private func messageForHTTPStatusCode(statusCode: Int) -> String {
		return "HTTP Response: \(statusCode) - \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))"
	}
	
	func messageForError(error: NSError) -> String {
		return "RemoteConnectionManager - Error fetching remote data" + "\n" + "\(error.localizedDescription)"
	}
	
}