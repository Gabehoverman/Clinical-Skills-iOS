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
    var disclaimerViewController: DisclaimerViewController?
    
	override func viewDidLoad() {
		self.displayViewControllerForSegmentIndex(0)
	}
	
	func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
		if index == 0 {
			if self.personnelTableViewController == nil {
				self.personnelTableViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.controller.personnelAcknowledgementTableViewController) as? PersonnelAcknowledgementTableViewController
			}
			return self.personnelTableViewController
		} else if index == 1 {
			if self.softwareTableViewController == nil {
				self.softwareTableViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.controller.softwareAcknowledgementTableViewController) as? SoftwareAcknowledgementTableViewController
			}
			return self.softwareTableViewController
        } else {
            if self.disclaimerViewController == nil {
                self.disclaimerViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.controller.disclaimerViewController) as?
                    DisclaimerViewController
            }
            
            return self.disclaimerViewController
        }
	}
	
	func displayViewControllerForSegmentIndex(_ index: Int) {
		if let viewController = self.viewControllerForSelectedSegmentIndex(index) {
			self.addChildViewController(viewController)
			viewController.didMove(toParentViewController: self)
			
			viewController.view.frame = self.contentView.bounds
			self.contentView.addSubview(viewController.view)
			
			self.currentViewController = viewController
		}
	}
	
	@IBAction func acknowledgementTypeChanged(_ sender: UISegmentedControl) {
		self.currentViewController?.view.removeFromSuperview()
		self.currentViewController?.removeFromParentViewController()
		
		self.displayViewControllerForSegmentIndex(sender.selectedSegmentIndex)
	}
	
	
}
