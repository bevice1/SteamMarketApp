//
//  AddButtonViewController.swift
//  SteamApp
//
//  Created by Benedikt Kaiser on 28.01.21.
//

import UIKit
import CoreData

class AddButtonViewController: UIViewController{
    
    var suggestions:[MarketItemsResponse] = []
    var selected = false
    
    @IBOutlet weak var suggestionTable: UITableView!
    @IBOutlet weak var prizeField: UITextField!
    @IBOutlet weak var itemField: UITextField!
    var nameCollection: [String] = []
    var chosenItemName: String = ""
    var responseCollection: [MarketItemsResponse] = []
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        itemField.attributedPlaceholder = NSAttributedString(string: "enter a item",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        prizeField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        prizeField.attributedPlaceholder = NSAttributedString(string: "purchase price",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        suggestionTable.register(UINib(nibName:"SuggestionCell", bundle:nil), forCellReuseIdentifier: "SuggestionCell")
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if text!.count > 2 {
            suggestions = searchMarketName(substring: text!)
            suggestionTable.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let unwindToCollectionView = segue.destination as? CollectionViewController else {return}
        
        let  possibilities = searchMarketName(substring: itemField.text!)
        for elem in responseCollection{
            if elem.market_hash_name == itemField.text{
                
                unwindToCollectionView.dashboardIcons.append(MarketItem(elem: suggestions[index], purchasePrize: Double(prizeField.text!) ?? 0.0))
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                if let context = appDelegate?.persistentContainer.viewContext{
                    var dashboard = Dashboard(context: context)
                    dashboard.name = elem.market_hash_name
                    dashboard.purchasePrize = Double(prizeField.text!) ?? 0.0
                    appDelegate?.saveContext()
                }
            }
        }
        
    }
    
    
    
    func searchMarketName(substring: String) -> [MarketItemsResponse] {
        var resultingArray: [MarketItemsResponse] = []
        
        for elem in responseCollection {
            if elem.market_hash_name.uppercased().contains(substring.uppercased()) {
                resultingArray.append(elem)
            }
        }
        return resultingArray
    }
}

extension AddButtonViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemField.text = suggestions[indexPath.row].market_hash_name
        selected = true
        index = indexPath.row
    }
}

extension AddButtonViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
        cell.suggestionLabel.text = suggestions[indexPath.row].market_hash_name
        return cell
    }
    
    
}
