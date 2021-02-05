//
//  SuggestionCell.swift
//  SteamApp
//
//  Created by Konrad Plasser on 03.02.21.
//

import UIKit

class SuggestionCell: UITableViewCell {

    @IBOutlet weak var suggestionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
