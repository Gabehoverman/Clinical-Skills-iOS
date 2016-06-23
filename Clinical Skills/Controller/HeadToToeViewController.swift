//
//  HeadToToeViewController.swift
//  Clinical Skills
//
//  Created by Matthew Taylor on 6/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//
import Foundation
import UIKit

class HeadToToeViewController : UIViewController {
    
    // MARK: - Properties
    
    var documentController: UIDocumentInteractionController?
    var dismissing: Bool?
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        if let url = NSBundle.mainBundle().URLForResource("Head To Toe", withExtension: "pdf") {
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
    
    // MARK: - Interface Builder Connections
    
    @IBAction func show(sender: UIButton) {
        self.dismissing = false
        self.presentPreview()
    }
    
    // MARK: - Navigation Methods
    
    func presentPreview() {
        if let dismissing = self.dismissing where dismissing == false {
            if self.documentController != nil {
                self.documentController!.presentPreviewAnimated(true)
            }
        }
    }
    
}

// MARK: - Document Interface Controller Delegate Methods

extension HeadToToeViewController : UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        self.dismissing = true
    }
}