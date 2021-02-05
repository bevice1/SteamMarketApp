////
////  TableViewController.swift
////  SteamApp
////
////  Created by Benedikt Kaiser on 26.01.21.
////
//
//import UIKit
//
//struct ItemResponse : Decodable{
//
//       let success:Bool
//
//       let lowest_price:Double
//
//       let volume:Double
//
//       let median_price:Double
//
//   }
//
//struct MarketItem{
//    let name: String
//    let iteminfos: ItemResponse
//    let purchasePrize: Double
//}
//
//class TableViewController: UIViewController{
//
//    private var dashboadIcons: [MarketItem] = []
//
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        collectionView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "MainCell")
//
//        dashboadIcons = [MarketItem(name: "Karambit", iteminfos: ItemResponse(success: true, lowest_price: 5, volume: 1000, median_price: 7), purchasePrize:  4),MarketItem(name: "Butterfliege", iteminfos: ItemResponse(success: true, lowest_price: 500, volume: 1000, median_price: 70), purchasePrize:  4)]
////
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//
//
//}
//
//extension TableViewController: UICollectionViewDelegate{
//
//}
//
//extension TableViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dashboadIcons.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
//        cell.nameLabel?.text = dashboadIcons[indexPath.section].name
//        cell.increaseLabel.text = String( dashboadIcons[indexPath.section].iteminfos.median_price - dashboadIcons[indexPath.section].purchasePrize)
//        cell.valueLabel.text = String(dashboadIcons[indexPath.section].iteminfos.median_price)
//        return cell
//
//
//
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Dashboad"
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//
//
//
//}
