//
//  InventoryTableViewCell.swift
//  SwiftCart Admin
//
//  Created by Mac on 27/06/2024.
//

import UIKit
import Kingfisher

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemId: UILabel!
    @IBOutlet weak var itemSubTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemAvailable: UILabel!

    func config(item: InventoryLevel){
        
        itemImage.kf.setImage(with: URL(string: item.imageSrc ?? ""), placeholder: K.Assets.Image.InventoryItem)
        itemTitle.text = item.title
        itemId.text = "Item Id: \(item.inventoryItemId)"
        itemSubTitle.text = item.variant
        itemPrice.text = item.price
        itemAvailable.text = "Quantaty: \(item.available ?? 0)"

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
