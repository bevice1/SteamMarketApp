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
    
    @IBAction func unwindToBucketListController(segue: UIStoryboardSegue){
//        updateDashboadentry()
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dashboardIcons: [MarketItem] = []
    var responseArray: [MarketItemsResponse] = []
    
    
    
    let skins = ["Chroma Case" : "Chroma%20Case",
                 "Chroma 2 Case" : "Chroma%202%20Case",
                 "Spectrum Case" : "Spectrum%20Case",
                 "Spectrum 2 Case" : "Spectrum%202%20Case",
                 "Prisma Case" : "Prisma%20Case"]
    
    var itemResponses:[ItemResponse?] = []
    
    var namesDidLoad = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardIcons.append(MarketItem(elem:MarketItemsResponse(image: "https://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5lpKKqPrxN7LEmyVQ7MEpiLuSrYmnjQO3-UdsZGHyd4_Bd1RvNQ7T_FDrw-_ng5Pu75iY1zI97bhLsvQz",
            border_color: "#D2D2D2",
            market_hash_name:"AK-47 | Redline (Field-Tested)", prices: Price(latest: 1)),purchasePrize: 3))
        dashboardIcons.append(MarketItem(elem:MarketItemsResponse(image: "https://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5lpKKqPrxN7LEmyVQ7MEpiLuSrYmnjQO3-UdsZGHyd4_Bd1RvNQ7T_FDrw-_ng5Pu75iY1zI97bhLsvQz",
            border_color: "#D2D2D2",
            market_hash_name:"AK-47 | Redline (Field-Tested)", prices: Price(latest: 1)),purchasePrize: 0))
        dashboardIcons.append(MarketItem(elem:MarketItemsResponse(image: "https://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5lpKKqPrxN7LEmyVQ7MEpiLuSrYmnjQO3-UdsZGHyd4_Bd1RvNQ7T_FDrw-_ng5Pu75iY1zI97bhLsvQz",
            border_color: "#D2D2D2",
            market_hash_name:"AK-47 | Redline (Field-Tested)", prices: Price(latest: 1)),purchasePrize: 3))
        dashboardIcons.append(MarketItem(elem:MarketItemsResponse(image: "https://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5lpKKqPrxN7LEmyVQ7MEpiLuSrYmnjQO3-UdsZGHyd4_Bd1RvNQ7T_FDrw-_ng5Pu75iY1zI97bhLsvQz",
            border_color: "#D2D2D2",
            market_hash_name:"AK-47 | Redline (Field-Tested)", prices: Price(latest: 1)),purchasePrize: 3))
        
//        updateDashboadentry()
        
        if !namesDidLoad {
            print("loadingnames")
            loadNames()
        }
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        collectionView.collectionViewLayout = layout
        
        
        collectionView.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let request = NSFetchRequest<Currency>(entityName: "Currency")
        if let context = appDelegate?.persistentContainer.viewContext{
            let readEntry = try? context.fetch(request)
            if readEntry == []{
                
                if let viewContext = appDelegate?.persistentContainer.viewContext{
                    let currency = Currency(context: viewContext)
                    currency.currencyString = "$"
                    appDelegate?.saveContext()
                }
                
                
            }
            
        }
        
        
    }
    func test(){
        let test = searchMarketName(substring: "asi")
        for elem in test{
            print(elem.market_hash_name)
        }
    }
    
    func loadNames() {
        //        print("erster aufruf")
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
                    //
                    
                    let decodedResponse = try JSONDecoder().decode(AllMarketItemsResponse.self, from: data)
                    for elem in decodedResponse.data{
                        self.responseArray.append(elem)
                    }
                    print("doneloadingnames")
//                    self.test()
                    //                    print(self.responseArray)
                    //                    self.pokeList.append(contentsOf: decodedResponse.results)
                    DispatchQueue.main.async {
                        //                        self.tableView.reloadData()
                        
                    }
                    
                    
                    
                    
                }else{
                    print("error")
                }
            }catch let error{
                print(error)
            }
            
        }.resume()
        
        
    }
    
    
    
    let BASE_URL:String = "https://api.steamapis.com/market/item/730/"
    
//    func updateDashboadentry() {
//        print("erster aufruf")
//        var JSON = ""
//        for var elem in dashboardIcons{
//            print("t.er aufruf")
//            if let iteminfo =  elem.iteminfos{
//
//            }else{
//                print("anfang:"+elem.name+"ende")
//                let weatherURL = URL(string: BASE_URL + elem.name + "?api_key=L9TzxRTty4RlnexsaLfeUH5OhpM")!
//                let request = URLRequest(url: weatherURL)
//                let config = URLSessionConfiguration.default
//                let urlSession = URLSession(configuration: config)
//                print(weatherURL)
//                urlSession.dataTask(with: request){ (data, response, error) in
//                    do{
//                        if let data = data, let result = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]{
//                            print(result)
//                            //                            JSON = "\(result)"
//                            //                            let jsonData = JSON.data(using: .utf8)
//                            //convert JSON to objects
//                            let decodedResponse = try JSONDecoder().decode(ItemResponse.self, from: data)
//                            elem.iteminfos = decodedResponse
//                            var elementIndex = self.dashboardIcons.searchForMarketItem(name: elem.name)
//                            if elementIndex != -1 {
//                                self.dashboardIcons[elementIndex].iteminfos = decodedResponse
//                                DispatchQueue.main.async {
//                                    self.collectionView.reloadData()
//                                }
//                            }
//
//
//
//
//                        }else{
//                            print("error")
//                        }
//                    }catch let error{
//                        print(error)
//                    }
//
//                }.resume()
//            }
//        }
//
//    }
    
    
    
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
        addButtonSegue.nameCollection = Array(skins.keys)
        addButtonSegue.responseCollection = responseArray
    }
    
}
extension CollectionViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("actionlistener")
    }
    
}

extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        let keyArray = Array(skins.keys)
        cell.configure(data: dashboardIcons[indexPath.row])
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 7, bottom: 0, right: 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
}
