//
//  SettingsViewController.swift
//  SteamApp
//
//  Created by Benedikt Kaiser on 28.01.21.
//

import UIKit

class SettingsViewController: UIViewController{
    var array:[String] = ["1","2","3","4","5"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad() //hallo Welt
    }

}
