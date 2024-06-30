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
        
        let valueType = rule.valueType == K.Value.Coupons.valueType[1]
        let isShipping = rule.targetType == K.Value.Coupons.targetType[1]
        
        imageTarget.image = isShipping ? K.Assets.Image.ShippingPlaceholder : valueType ? K.Assets.Image.PercentagePlaceholder : K.Assets.Image.PriceRulePlaceholder
        
        ruleTitle.text = rule.title
        ruleValue.text = "Value: \(rule.value ?? "0") \(valueType ? "%" : "$")"
        let date = rule.endsAt?.split(separator: "T")[0]
        ruleEnds.text = "Expiry Date: \(date ?? "None")"
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
