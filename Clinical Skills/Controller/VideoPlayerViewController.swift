//
//  VideoPlayerViewController.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 8/30/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var video: VideoLinkManagedObject?
    var videoLink: VideoLink?
    
    override func viewDidLoad() {
        
        //let url = URL(string: self.videoLink!.link)
     
        if self.video != nil {
            if let url = URL(string: self.video!.link) {
                let request = URLRequest(url: url)
                self.webView.loadRequest(request)
            }
        }
     
        
        titleLabel.text = "" //self.video?.title
        descriptionLabel.text = "" //self.video?.descrip
    }
    
    
}
