//
//  PriceRuleTableViewCell.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import UIKit

class PriceRuleTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTarget: UIImageView!
    @IBOutlet weak var ruleTitle: UILabel!
    @IBOutlet weak var ruleValue: UILabel!
    @IBOutlet weak var ruleEnds: UILabel!

    func configuration(for rule: PriceRule){
        
        let valueType = rule.valueType == K.Enums.Coupons.valueType[0]
        let isShipping = rule.targetType == K.Enums.Coupons.targetType[1]
        
        imageTarget.image = isShipping ? K.Assets.Image.ShippingPlaceholder : valueType ? K.Assets.Image.PriceRulePlaceholder : K.Assets.Image.DiscountPlaceholder
        
        ruleTitle.text = rule.title
        ruleValue.text = "Value: \(rule.value ?? "0") \(valueType ? "$" : "%")"
        ruleEnds.text = "Expiry Date: \(rule.endsAt ?? "None")"
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
