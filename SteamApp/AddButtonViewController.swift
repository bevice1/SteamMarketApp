//
//  AddButtonViewController.swift
//  SteamApp
//
//  Created by Benedikt Kaiser on 28.01.21.
//

import UIKit

class AddButtonViewController: UIViewController{
    
    var suggestions:[MarketItemsResponse] = []
    
    @IBOutlet weak var suggestionTable: UITableView!
    @IBOutlet weak var prizeField: UITextField!
    @IBOutlet weak var itemField: UITextField!
    var nameCollection: [String] = []
    var chosenItemName: String = ""
    var responseCollection: [MarketItemsResponse] = []
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenItemName = nameCollection[0]
        
        itemField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//        suggestions.append(MarketItemsResponse(image: "test.png",border_color: "#789078",market_hash_name: "Knife"))
       /* suggestions.append(MarketItemsResponse(image: "test.png",border_color: "#789078",market_hash_name: "Knife"))
        suggestions.append(MarketItemsResponse(image: "test.png",border_color: "#789078",market_hash_name: "Knife"))
        suggestions.append(MarketItemsResponse(image: "test.png",border_color: "#789078",market_hash_name: "Knife"))*/
        
        suggestionTable.register(UINib(nibName:"SuggestionCell", bundle:nil), forCellReuseIdentifier: "SuggestionCell")
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if text!.count > 2 {
            print(text)
            suggestions = searchMarketName(substring: text!)
            suggestionTable.reloadData()
            print(suggestions)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let unwindToCollectionView = segue.destination as? CollectionViewController else {return}
        unwindToCollectionView.dashboardIcons.append(MarketItem(elem: suggestions[index], purchasePrize: Double(prizeField.text!) ?? 0.0))
//        unwindToCollectionView.dashboardIcons.append(MarketItem(name: itemField.text!, iteminfos: nil, purchasePrize: Double(prizeField.text!) ?? 0.0))
//        unwindToCollectionView.dashboardIcons.append(MarketItem(name: <#T##String#>, iteminfos: <#T##ItemResponse?#>, purchasePrize: <#T##Double#>))
    }
    
    
    
    func searchMarketName(substring: String) -> [MarketItemsResponse] {
        var resultingArray: [MarketItemsResponse] = []
        
        for elem in responseCollection {
            if elem.market_hash_name.uppercased().contains(substring.uppercased()) {
                resultingArray.append(elem)
                elem.market_hash_name
            }
        }
        return resultingArray
    }
}

extension AddButtonViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemField.text = suggestions[indexPath.row].market_hash_name
        index = indexPath.row
//        print(responseCollection[indexPath.row].market_hash_name)
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
