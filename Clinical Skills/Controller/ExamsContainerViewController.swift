//
//  ExamsContainerViewController.swift
//  Clinical Skills
//
//  Created by Nick on 3/31/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class ExamsContainerViewController : UIViewController {
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var segmentControl: UISegmentedControl!
	
	var currentViewController: UIViewController?
	var specialTestsTableViewController: SpecialTestsTableViewController?
	var basicExamsTableViewController: UIViewController?
	
	var component: Component?
	
	override func viewDidLoad() {
		self.displayViewControllerForSegmentIndex(0)
	}
	
	func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
		if index == 0 {
			if self.specialTestsTableViewController == nil {
				self.specialTestsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.controller.specialTestsTableViewController) as? SpecialTestsTableViewController
				self.specialTestsTableViewController?.component = self.component
			}
			return self.specialTestsTableViewController
		} else {
			if self.basicExamsTableViewController == nil {
				self.basicExamsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.controller.basicExamsTableViewController)
			}
			return self.basicExamsTableViewController
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
	
	@IBAction func tabChanged(sender: UISegmentedControl) {
		self.currentViewController?.view.removeFromSuperview()
		self.currentViewController?.removeFromParentViewController()
		
		self.displayViewControllerForSegmentIndex(sender.selectedSegmentIndex)
	}
	
}