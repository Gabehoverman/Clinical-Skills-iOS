//
//  OfflineTableViewController.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 7/12/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class OfflineTableViewController: UITableViewController {
    
    
    let Abdomen = System(id: 1, name:"Abdomen",details:"none")
    let Cardio = System(id: 2, name:"Cardiovascular", details:"none")
    let Eye = System(id:3, name:"Eye", details:"none")
    let Head = System(id:4, name:"Head, Ears, Nose, Neck, Throat", details:"none")
    let Musc = System(id:5, name:"Musculoskeletal", details:"none")
    let Neur = System(id:6, name:"Neurological", details:"none")
    let Resp = System(id:7, name:"Respiratory", details:"none")
    let Vita = System(id:8, name:"Vital Signs", details:"none")
    
    override func viewDidLoad() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Hardcoded array */
        let tabArr:[System] = [Abdomen, Cardio, Eye, Head, Musc, Neur, Resp, Vita]
        
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        cell.textLabel?.text = tabArr[indexPath.item].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabArr:[System] = [Abdomen, Cardio, Eye, Head, Musc, Neur, Resp, Vita]
        //self.DocPreview(tabArr[indexPath.item])
        self.performSegue(withIdentifier: StoryboardIdentifiers.segue.toComponentFile, sender: tabArr[indexPath.item])
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardIdentifiers.segue.toComponentFile {
            if let destination = segue.destination as? ComponentFileController {
                if let system = sender as? System {
                    destination.system = system
                }
            }
        }
    }
    
    func DocPreview(_ sender: Any?) {
        let pdf = Bundle.main.url(forResource: sender as! String, withExtension: "docx")
        //webview.loadRequest(URLRequest(url: pdf))
        
    }
    
}
