//
//  SystemMenuViewController.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 8/28/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class SystemMenuViewController : UIViewController {
    
    @IBOutlet weak var ClinicalTestButton: UIView!
    var documentController: UIDocumentInteractionController?
  
    var webView: UIWebView?
    var dismissing: Bool?
    var system: System?
    var seg: String?
    
    @IBAction func toDetailOverview(_ sender: Any) {
        seg = "toDetailOverview"
        self.performSegue(withIdentifier: "toComponentTable", sender: system)
    }
    
    @IBAction func toClinicalTests(_ sender: Any) {
        seg = "toSpecialTests"
        self.performSegue(withIdentifier: "toComponentTable", sender: system)
    }
    
    override func viewDidLoad() {
    }
    
    @IBAction func toReviewVideos(_ sender: Any) {
        self.performSegue(withIdentifier: "toReviewVideos", sender: system)
    }
    
    
    @IBAction func toPdfReview(_ sender: Any) {
        self.performSegue(withIdentifier: "toPDFReview", sender: system)
        
       /*let systemFileName = "Abdomen System";
        if let url = Bundle.main.url(forResource: systemFileName, withExtension: "docx") {
            let webView = UIWebView(frame: self.view.frame)
            webView.loadRequest(URLRequest(url: url))
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.scalesPageToFit = true
            webView.frame.origin.y = 50
            view.addSubview(webView)
            
            //self.documentController = UIDocumentInteractionController(url: url)
            //self.documentController!.delegate = self as! UIDocumentInteractionControllerDelegate
            //self.dismissing = false
        }*/

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? PDFReviewViewController {
                if let system = sender as? System {
                    destination.system = system
                }
            }
        if let destination = segue.destination as? PDFReviewViewController {
            if let system = sender as? System {
                destination.system = system
            }
        }
        if let destintation = segue.destination as? DetailOverviewComponentViewController {
            if let system = sender as? System {
                destintation.system = system
                destintation.seg = seg
            }
        }
        if let destination = segue.destination as? VideoTableViewController {
            if let system = sender as? System {
                destination.system = system
            }
        }
    }
    
}
