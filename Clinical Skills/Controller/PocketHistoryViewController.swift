//
//  PocketHistoryViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/7/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class PocketHistoryViewController : UIViewController {
	
	// MARK: - Properties
	
	var documentController: UIDocumentInteractionController?
	var dismissing: Bool?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if let url = NSBundle.mainBundle().URLForResource("Pocket History Guide", withExtension: "pdf") {
			self.documentController = UIDocumentInteractionController(URL: url)
			self.documentController!.delegate = self
			self.dismissing = false
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		self.presentPreview()
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.dismissing = false
	}
	
	// MARK: - IB Actions
	
	@IBAction func show(sender: UIButton) {
		self.dismissing = false
		self.presentPreview()
	}
	
	// MARK: - Utility Methods
	
	func presentPreview() {
		if let dismissing = self.dismissing where dismissing == false {
			if self.documentController != nil {
				self.documentController!.presentPreviewAnimated(true)
			}
		}
	}
	
}

// MARK: - Document Interface Controller Delegate Methods

extension PocketHistoryViewController : UIDocumentInteractionControllerDelegate {
	func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
		return self.navigationController!
	}
	
	func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
		self.dismissing = true
	}
}