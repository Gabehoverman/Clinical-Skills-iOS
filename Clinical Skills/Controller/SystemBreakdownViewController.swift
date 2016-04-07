//
//  SystemBreakdownViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class SystemBreakdownViewController : UIViewController {
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var contentView: UIView!
	
	var currentViewController: UIViewController?
	var componentsTableViewController: ComponentsTableViewController?
	var examTechniquesTableViewController : ExamTechniquesTableViewController?
	
	var system: System?
	
	override func viewDidLoad() {
		self.displayViewControllerForSegmentIndex(0)
	}
	
	func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
		if index == 0 {
			if self.componentsTableViewController == nil {
				self.componentsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.controller.componentsTableViewController) as? ComponentsTableViewController
				self.componentsTableViewController?.system = self.system
			}
			return self.componentsTableViewController
		} else {
			if self.examTechniquesTableViewController == nil {
				self.examTechniquesTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifiers.controller.examTechniquesTableViewController) as? ExamTechniquesTableViewController
				self.examTechniquesTableViewController?.system = system
			}
			return self.examTechniquesTableViewController
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
	
	@IBAction func segmentChanged(sender: UISegmentedControl) {
		self.currentViewController?.view.removeFromSuperview()
		self.currentViewController?.removeFromParentViewController()
		
		self.displayViewControllerForSegmentIndex(sender.selectedSegmentIndex)
	}
	
}