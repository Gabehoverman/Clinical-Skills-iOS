//
//  DrawerContainerViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick on 1/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

enum DrawerState {
	case BothClosed
	case LeftOpen
	case RightOpen
}

class DrawerContainerViewController: UIViewController {
	
	var mainNavigationController: UINavigationController!
	var mainViewController: SystemsTableViewController!
	
	var currentDrawerState: DrawerState = .BothClosed {
		didSet {
			self.showShadow(self.currentDrawerState != .BothClosed)
		}
	}
	var leftDrawerViewController: UIViewController?
	var drawerOpen: Bool {
		get {
			return self.currentDrawerState != .BothClosed
		}
	}
	
	let drawerExpandedOffset: CGFloat = 60
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.mainViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(SystemsTableViewController.storyboardIdentifier) as! SystemsTableViewController
		self.mainViewController.delegate = self
		self.mainNavigationController = UINavigationController(rootViewController: self.mainViewController)
		self.view.addSubview(self.mainNavigationController.view)
		self.addChildViewController(self.mainNavigationController)
		self.mainNavigationController.didMoveToParentViewController(self)
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
		self.mainNavigationController.view.addGestureRecognizer(panGestureRecognizer)
	}
	
}

extension DrawerContainerViewController: DrawerMainViewControllerDelegate {
	func toggleLeftDrawer() {
		let alreadyOpen = self.currentDrawerState != DrawerState.BothClosed
		if !alreadyOpen {
			self.addLeftDrawer()
		}
		self.animateLeftDrawer(!alreadyOpen)
	}
	
	func addLeftDrawer() {
		if self.leftDrawerViewController == nil {
			self.leftDrawerViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(SettingsDrawerViewController.storyboardIdentifier) as! SettingsDrawerViewController
			self.view.insertSubview(self.leftDrawerViewController!.view, atIndex: 0)
			self.addChildViewController(self.leftDrawerViewController!)
			self.leftDrawerViewController!.didMoveToParentViewController(self)
		}
	}
	
	func animateLeftDrawer(shouldExpand: Bool) {
		if shouldExpand {
			self.animateXPosition(CGRectGetWidth(self.mainNavigationController.view.frame) - self.drawerExpandedOffset)
			self.currentDrawerState = .LeftOpen
		} else {
			self.animateXPosition(0) { finished in
				self.leftDrawerViewController!.view.removeFromSuperview()
				self.leftDrawerViewController = nil
				self.currentDrawerState = .BothClosed
			}
		}
	}
	
	func animateXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
		UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
			self.mainNavigationController.view.frame.origin.x = targetPosition
			}, completion: completion)
	}
	
	func showShadow(shouldShowShadow: Bool) {
		if shouldShowShadow {
			self.mainNavigationController.view.layer.shadowOpacity = 0.8
		} else {
			self.mainNavigationController.view.layer.shadowOpacity = 0.0
		}
	}
}

extension DrawerContainerViewController: UIGestureRecognizerDelegate {
	func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		let gestureLeftOrigin = recognizer.velocityInView(self.view).x > 0
		if self.currentDrawerState == .BothClosed && !gestureLeftOrigin {
			return
		}
		switch(recognizer.state) {
		case .Began:
			if self.currentDrawerState == .BothClosed {
				if gestureLeftOrigin {
					self.addLeftDrawer()
				}
				self.showShadow(true)
			}
		case .Changed:
			recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(self.view).x
			recognizer.setTranslation(CGPointZero, inView: self.view)
		case .Ended:
			if self.leftDrawerViewController != nil {
				let isBeyondMidpoint = recognizer.view!.center.x > self.view.bounds.size.width
				self.animateLeftDrawer(isBeyondMidpoint)
			}
		default:
			break
		}
	}
}