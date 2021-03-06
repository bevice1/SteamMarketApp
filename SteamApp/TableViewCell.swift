//
//  TableViewCell.swift
//  SteamApp
//
//  Created by Konrad Plasser on 05.02.21.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var actualLabel: UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var increaseLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
        // Configure the view for the selected state
    }
    
    
    public func configure(data: MarketItem){
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
        
        
        var imageURL = URL(string:data.elem.image)
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: imageURL!)
            let img  = UIImage(data: imageData!)
            DispatchQueue.main.async {
                self.imageView!.image = img
                self.contentView.layer.borderWidth = 2
                self.contentView.layer.borderColor = UIColor(hex: data.elem.border_color)?.cgColor
                self.progress.stopAnimating()
            }
        }

        nameLabel.text = data.elem.market_hash_name
        valueLabel.text = String(data.purchasePrize.format(f: ".2")) + currency

        if data.purchasePrize > data.elem.prices.latest{
            increaseLabel.textColor = UIColor.red
        }else{
            increaseLabel.textColor = UIColor.green
        }
        increaseLabel.text = String(data.elem.prices.latest.format(f: ".2")) + currency
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5))
        imageView?.frame = CGRect( x: 20, y: 50, width: 320, height: 200)
    }
    
}



extension UIColor{
    public convenience init?(hex:String){
        let r,g,b, a:CGFloat
        
        if hex.hasPrefix("#"){
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6{
                let scanner = Scanner(string: hexColor)
                var hexNumber:UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber){
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(1)
                    self.init(red: r, green: g , blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}


extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
