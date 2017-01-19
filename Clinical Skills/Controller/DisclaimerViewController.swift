//
//  DisclaimerViewController.swift
//  Clinical Skills
//
//  Created by Matthew Taylor on 11/15/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class DisclaimerViewController : UIViewController {
    
    // MARK: - Properties
    
    var documentController: UIDocumentInteractionController?
    var dismissing: Bool?
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        if let url = Bundle.main.url(forResource: "Disclaimer", withExtension: "pdf") {
            self.documentController = UIDocumentInteractionController(url: url)
            self.documentController!.delegate = self
            self.dismissing = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.presentPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismissing = false
    }
    
    // MARK: - Interface Builder Connections
    
    @IBAction func show(_ sender: UIButton) {
        self.dismissing = false
        self.presentPreview()
    }
    
    // MARK: - Navigation Methods
    
    func presentPreview() {
        if let dismissing = self.dismissing, dismissing == false {
            if self.documentController != nil {
                self.documentController!.presentPreview(animated: true)
            }
        }
    }
    
}

// MARK: - Document Interface Controller Delegate Methods

extension DisclaimerViewController : UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        self.dismissing = true
    }
}
