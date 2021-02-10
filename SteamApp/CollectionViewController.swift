//
//  CollectionViewController.swift
//  SteamApp
//
//  Created by Benedikt Kaiser on 27.01.21.
//

import UIKit
import CoreData

struct ItemResponse : Decodable{
    
    let success:Bool
    
    let lowest_price:String
    
    let volume:String
    
    let median_price:String
    
}

struct MarketItem{
    
    
    let elem: MarketItemsResponse
    let purchasePrize: Double
}

struct Price: Decodable{
    let latest: Double
}
struct MarketItemsResponse: Decodable{
    let image: String
    let border_color: String
    let market_hash_name: String
    let prices: Price
}

struct AllMarketItemsResponse: Decodable {
    let appID: Int
    let data: [MarketItemsResponse]
}

extension Array where Element == MarketItem{
    func searchForMarketItem(name: String)-> Int{
        var i = 0
        for elem in self{
            if elem.elem.market_hash_name == name{
                return i
            }
            i+=1
            
        }
        return -1 //if elemnt is not found
    }
}
class CollectionViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var progressStart: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBAction func unwindToBucketListController(segue: UIStoryboardSegue){
        loadDashboardIcons()
        tableView.reloadData()
    }
    
    
    
    var refreshControl = UIRefreshControl()
    var dashboardIcons: [MarketItem] = []
    var responseArray: [MarketItemsResponse] = []
    var currency: String = "€"
    
    
    var namesDidLoad = false
    override func viewDidLoad() {
        addButton.isEnabled = false
        addButton.isHidden = true
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //refresh specific properties
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Refresh", attributes: attributes)
        
        refreshControl.tintColor = UIColor.white
        
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        

        
        tableView.register(UINib(nibName:"TableViewCell", bundle:nil), forCellReuseIdentifier: "TableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let request = NSFetchRequest<Currency>(entityName: "Currency")
        if let context = appDelegate?.persistentContainer.viewContext{
            if let readEntry = try? context.fetch(request){
                for elem in readEntry{
                    currency = elem.currencyString!
                }
            }else{
                    let currency = Currency(context: context)
                    currency.currencyString = "€"
                    appDelegate?.saveContext()
                }
                
                
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        responseArray = []
        loadNames()
    }
    
    func loadNames() {
        var JSON = ""
        namesDidLoad = true
        let pokeUrl = URL(string: "https://api.steamapis.com/market/items/730?api_key=L9TzxRTty4RlnexsaLfeUH5OhpM")!
        let request = URLRequest(url: pokeUrl)
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        print(pokeUrl)
        urlSession.dataTask(with: request){ (data, response, error) in
            do{
                if let data = data, let result = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
                    
                    
                    let decodedResponse = try JSONDecoder().decode(AllMarketItemsResponse.self, from: data)
                    for elem in decodedResponse.data{
                        self.responseArray.append(elem)
                    }
                    print("done loading names")
                    DispatchQueue.main.async {
                        self.loadDashboardIcons()
                        self.addButton.isHidden = false
                        self.addButton.isEnabled = true
                    }
                }else{
                    print("error")
                }
            }catch let error{
                print(error)
            }
        }.resume()
    }
    
    func loadDashboardIcons() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        dashboardIcons = []
        let request = NSFetchRequest<Dashboard>(entityName: "Dashboard")
        if let context = appDelegate?.persistentContainer.viewContext{
            if let readEntry = try? context.fetch(request){
                if readEntry.count == 0{
                    progressStart.stopAnimating()
                }
                for elem in readEntry{
                    print(elem.name)
                    if let marketHashName = elem.name{
                        var hashName = searchMarketName(substring: marketHashName)
                        for marketElement in hashName{
                            if marketElement.market_hash_name == elem.name {
                                self.dashboardIcons.append(MarketItem(elem: marketElement, purchasePrize: elem.purchasePrize))
                            }
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    
    let BASE_URL:String = "https://api.steamapis.com/market/item/730/"
    
    
    func searchMarketName(substring: String) -> [MarketItemsResponse] {
        var resultingArray: [MarketItemsResponse] = []
        
        for elem in responseArray {
            if elem.market_hash_name.uppercased().contains(substring.uppercased()) {
                resultingArray.append(elem)
            }
        }
        return resultingArray
    }
    
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addButtonSegue"{
            let popoverVc = segue.destination
            
            popoverVc.modalPresentationStyle = .popover
            popoverVc.popoverPresentationController?.delegate = self
            popoverVc.preferredContentSize = CGSize(width: 414, height: 400)
        }
        
        guard let addButtonSegue = segue.destination as? AddButtonViewController else {return}

        addButtonSegue.responseCollection = responseArray
    }
    
    @objc func refresh(_ sender: AnyObject) {
        //refresh data of Tableview
        responseArray = []
        loadNames()
        refreshControl.endRefreshing()
    }
    
}



extension CollectionViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension CollectionViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch(editingStyle){
        case .delete:
            dashboardIcons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate

            let request = NSFetchRequest<Dashboard>(entityName: "Dashboard")
            if let context = appDelegate?.persistentContainer.viewContext{
                let readEntry = try? context.fetch(request)
                context.delete((readEntry?[indexPath.row])!)
                appDelegate?.saveContext()

            }
            
        default:
            break
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardIcons.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.configure(data: dashboardIcons[indexPath.row])
        progressStart.stopAnimating()
        return cell
    }
    
    
}
