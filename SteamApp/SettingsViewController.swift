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
 
        var currentStoredIndex = 0
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let request = NSFetchRequest<Currency>(entityName: "Currency")
        if let context = appDelegate?.persistentContainer.viewContext{
            if let readEntry = try? context.fetch(request){
                
                for elem in readEntry{
                    switch elem.currencyString {
                    case "€":
                        currentStoredIndex = 0
                    case "$":
                        currentStoredIndex = 1
                    case "£":
                        currentStoredIndex = 2
                    default:
                        currentStoredIndex = 0
                    }
                }
                
            }
        }
        segment.selectedSegmentIndex = currentStoredIndex
        
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
                switch segment.selectedSegmentIndex{
                case 0:
                    print("Currency is $")
                    currency.currencyString = "€"
                    
                case 1:
                    print("Currency is €")
                    currency.currencyString = "$"
                    
                case 2:
                    print("Currency is Pfund")
                    currency.currencyString = "£"
                    
                    
                    
                default:
                    print("error")
                }
                
                appDelegate?.saveContext()
            }
        }
        
    }
    
    
}
