//
//  DetailViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/15/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var detailsText: String = ""
	
	@IBOutlet weak var detailsTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.detailsTextView.text = self.detailsText
    }

}
