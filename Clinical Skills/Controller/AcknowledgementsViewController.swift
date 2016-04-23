//
//  AcknowledgementsViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/22/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class AcknowledgementsViewController : UIViewController {
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var acknowledgementTypeSegmentedControl: UISegmentedControl!
	
	var currentViewController: UIViewController?
	var personnelTableViewController: PersonnelAcknowledgementTableViewController?
	var softwareTableViewController: SoftwareAcknowledgementTableViewController?
	
	var acknowledgementsManager: AcknowledgementsManager?
	
	override func viewDidLoad() {
		self.acknowledgementsManager = AcknowledgementsManager()
		self.acknowledgementsManager!.process()
		self.displayViewControllerForSegmentIndex(0)
	}
	
	func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
		if index == 0 {
			if self.personnelTableViewController == nil {
				self.personnelTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.controller.personnelAcknowledgementTableViewController) as? PersonnelAcknowledgementTableViewController
				self.personnelTableViewController!.personnelAcknowledgements = self.acknowledgementsManager!.personnel
			}
			return self.personnelTableViewController
		} else {
			if self.softwareTableViewController == nil {
				self.softwareTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.controller.softwareAcknowledgementTableViewController) as? SoftwareAcknowledgementTableViewController
				self.softwareTableViewController!.softwareAcknowledgements = self.acknowledgementsManager!.software
			}
			return self.softwareTableViewController
		}
	}
	
	func displayViewControllerForSegmentIndex(index: Int) {
		if let viewController = self.viewControllerForSelectedSegmentIndex(index) {
			self.addChildViewController(viewController)
			viewController.didMoveToParentViewController(self)
			
			viewController.view.frame = self.contentView.bounds
			self.contentView.addSubview(viewController.view)
			
			self.currentViewController = viewController
		}
	}
	
	@IBAction func acknowledgementTypeChanged(sender: UISegmentedControl) {
		self.currentViewController?.view.removeFromSuperview()
		self.currentViewController?.removeFromParentViewController()
		
		self.displayViewControllerForSegmentIndex(sender.selectedSegmentIndex)
	}
	
	
}