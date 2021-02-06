//
//  CustomCollectionViewCell.swift
//  SteamApp
//
//  Created by Benedikt Kaiser on 27.01.21.
//

import UIKit
import CoreData

class CustomCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    @IBOutlet weak var actualLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var increaseLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    static let identifier = "CustomCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "CustomCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func configure(data: MarketItem){
        
        var imageURL = URL(string:data.elem.image)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
        
            let appDelegate = UIApplication.shared.delegate as? AppDelegate

            var currency = ""
            let request = NSFetchRequest<Currency>(entityName: "Currency")
            if let context = appDelegate?.persistentContainer.viewContext{
                if let readEntry = try? context.fetch(request){
                for elem in readEntry{
                    currency = elem.currencyString!
                }
                }
                
            }
//        imageView.image =
        nameLabel.text = data.elem.market_hash_name
        valueLabel.text = String(data.purchasePrize) + currency
        print(data.purchasePrize)
//            var medianPrice = iteminfo.median_price.replacingOccurrences(of: ",", with: ".").dropLast()
        if data.purchasePrize > data.elem.prices.latest{
            increaseLabel.textColor = UIColor.red
        }else{
            increaseLabel.textColor = UIColor.green
        }
        increaseLabel.text = String(data.elem.prices.latest) + currency
    }

}
