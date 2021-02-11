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
    var currency:String = ""
    
    @IBOutlet weak var suggestionTable: UITableView!
    @IBOutlet weak var prizeField: UITextField!
    @IBOutlet weak var itemField: UITextField!
    var nameCollection: [String] = []
    var chosenItemName: String = ""
    var responseCollection: [MarketItemsResponse] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        prizeField.addTarget(self, action: #selector(self.priceTextFieldDidChange(_:)), for: .editingChanged)
        
        
        itemField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        itemField.attributedPlaceholder = NSAttributedString(string: "enter an item name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        //        prizeField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        prizeField.attributedPlaceholder = NSAttributedString(string: currency,
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
        }else{
            //            man mag meinen dass da a suggestions = [] reinghört aber dann kanns es aus irgend am grund nimmer adden. So steht jz immer da alte vorschlag da a wenn ma es löscht
            suggestionTable.reloadData()
        }
    }
    
    
    @objc func priceTextFieldDidChange(_ textField: UITextField) {
        
        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            
            if let input = textField.text{
                if input.count > 0{
                    if input.last != Array(currency).first {
                        textField.text = input + currency
                    }else if input.count == 1{
                        textField.text = ""
                    }
                }
            }
            
            textField.selectedTextRange = textField.textRange(from: selectedRange.start, to: selectedRange.start)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let unwindToCollectionView = segue.destination as? CollectionViewController else {return}
    
        var currentCurrencyCode = ""
        switch unwindToCollectionView.currency{
        case "$":
            currentCurrencyCode = "USD"
        case "€":
            currentCurrencyCode = "EUR"
        case "£":
            currentCurrencyCode = "GBP"
        default:
            "error"
        }
        
        var rate = unwindToCollectionView.exchangeRates[currentCurrencyCode]!
        
        let  possibilities = searchMarketName(substring: itemField.text!)
        for elem in responseCollection{
            if elem.market_hash_name == itemField.text{
                
                var purchasePrize:Double = 0
                if prizeField.text!.last == Array(currency).first{
                    var prizeTxt = prizeField.text!
                    prizeTxt = String(prizeTxt.dropLast())
                    purchasePrize = Double(prizeTxt)! / rate
                }
                unwindToCollectionView.dashboardIcons.append(MarketItem(elem: suggestions[index], purchasePrize: purchasePrize))
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                if let context = appDelegate?.persistentContainer.viewContext{
                    var dashboard = Dashboard(context: context)
                    dashboard.name = elem.market_hash_name
                    dashboard.purchasePrize = purchasePrize 
                    appDelegate?.saveContext()
                }
            }
        }
        
    }
    
    
    
    func searchMarketName(substring: String) -> [MarketItemsResponse] {
        var resultingArray: [MarketItemsResponse] = []
        let searchString = substring.uppercased().split(separator: " ")
        
        
        for elem in responseCollection {
            var subStringsContained = 0
            
            for splitElem in searchString{
                if elem.market_hash_name.uppercased().contains(splitElem){
                    subStringsContained += 1
                }
            }
            
            if subStringsContained > 0 && subStringsContained == searchString.count {
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
