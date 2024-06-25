//
//  Constants.swift
//  SwiftCart Admin
//
//  Created by Mac on 19/06/2024.
//

import UIKit

public enum K {
    
    enum Main{
        static let storyboardName = "Main"
        static let authVCName = "AuthViewController"
        static let homeVCName = "HomeViewController"
        static let productDetail = "AddProductViewController"
        static let priceRuleDetail = "AddPriceRuleViewController"
        static let priceRulesVCName = "PriceRulesViewController"
        static let inventoryVCName = "InventoryViewController"
        static let editQuntatyVCName = "EditQuntatyViewController"
    }
    
    enum CustomView{
        static let defaultCellIdentifier = "defaultCell"
        static let homeProductCellIdentifier = "productCell"
        static let homeProductCellName = "HomeCollectionViewCell"
        static let addProductImageCellIdentifier = "productImageCell"
    }
    
    enum Title{
        static let home = "Home"
        static let coupons = "Coupons"
        static let inventory = "Inventory"
    }
    
    enum Enums{
        enum Auth{
            static let adminMail = "admin@swiftcart.com"
        }
        
        enum Product{
            static let vendors = ["ADIDAS", "ASICS TIGER", "CONVERSE", "DR MARTENS", "FLEX FIT", "HERSCHEL", "NIKE", "PALLADIUM", "PUMA", "SUPRA", "TIMBERLAND", "VANS"]
            static let productTypes = ["ACCESSORIES", "SHOES", "T-SHIRTS"]
        }
        
        enum Coupons{
            static let valueType = ["fixed_amount", "percentage"]
            static let targetType = ["line_item", "shipping_line"]
            static let allocationMethod = ["each", "across"]
        }
    }
    
    enum SystemImage{
        static let home = UIImage(systemName: "house")
        static let coupons = UIImage(systemName: "tag.slash")
        static let inventory = UIImage(systemName: "tray")
        static let trash = UIImage(systemName: "trash")
    }
    
    enum Assets{
        enum Color{
            static let accentColor = UIColor(named: "AccentColor")
            static let colorBlack = UIColor(named: "ColorBlack")
            static let colorRed = UIColor(named: "ColorRed")
            static let ColorWhite = UIColor(named: "ColorWhite")
            static let textBackground = UIColor(named: "TextBackgorund")
            static let textForeground = UIColor(named: "TextForeground")
            static let viewBackground = UIColor(named: "ViewBackgrond")
        }
        enum Image{
            static let productPlaceholder = UIImage(named: "ProductPlaceholder")
            static let PriceRulePlaceholder = UIImage(named: "PriceRulePlaceholder")
            static let DiscountPlaceholder = UIImage(named: "DiscountPlaceholder")
            static let ShippingPlaceholder = UIImage(named: "ShippingPlaceholder")
        }
    }
    
    enum Endpoint{
        enum Product{
            static let product = "products.json" // All Product & Add
            static let productDetail = "products/{ItemId}.json" // Delete & Update
        }
        enum Coupons{
            static let priceRules = "price_rules.json"
            static let priceRuleDetails = "price_rules/{ItemId}.json"
            static let addDiscount = "price_rules/{ItemId}/discount_codes.json"
        }
        enum Inventory{
            static let locationId: Int64 = 71569309743
            static let inventoryLevels = "locations/71569309743/inventory_levels.json"
            static let inventoryItem = "inventory_items.json?ids={ItemId}"
            static let setInventoryItem = "inventory_levels/set.json"
        }
    }
//    let endpoint = K.endPoints.getOrPostAddress.rawValue.replacingOccurrences(of: "{customer_id}", with: customerID)

    
}
