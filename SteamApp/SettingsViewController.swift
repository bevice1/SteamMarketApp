//
//  SettingsViewController.swift
//  SteamApp
//
//  Created by Benedikt Kaiser on 28.01.21.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController{
    var array:[String] = ["1","2","3","4","5"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad() //hallo Welt
        
//        segment.addTarget(self, action: #selector(segmentedControlValueChanged(segment: segment)), for:.touchUpInside)
//        switch segment.selectedSegmentIndex{
//        case 0:             print("Currency is $")
//
//        case 1:
//            print("Currency is €")
//
//        case 2:
//            print("Currency is Pfund")
//
//        default:
//            print("error")
//        }
        
        segment.addTarget(self, action: #selector(SettingsViewController.indexChanged(_:)), for: .valueChanged)
        
        
    }
    @objc func indexChanged(_ sender: UISegmentedControl) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let request = NSFetchRequest<Currency>(entityName: "Currency")
        if let context = appDelegate?.persistentContainer.viewContext{
            if let readEntry = try? context.fetch(request){
                for elem in readEntry{
                    context.delete(elem)
                }
            
            let currency = Currency(context: context)
            if segment.selectedSegmentIndex == 0 {
                print("Select €")
                currency.currencyString = "€"
            } else if segment.selectedSegmentIndex == 1 {
                print("Select $")
                currency.currencyString = "$"
            } else if segment.selectedSegmentIndex == 2 {
                print("Select Pfund")
                currency.currencyString = "£"
            }
            
            
            appDelegate?.saveContext()
            }
        }
       
    }


}
