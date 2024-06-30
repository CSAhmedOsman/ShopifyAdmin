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
        static let discountsVCName = "DiscountViewController"
        static let addDiscountVCName = "AddDiscountViewController"
        static let profileVCName = "ProfileViewController"
        static let contactUsVCName = "ContactUsViewController"
        static let aboutUsVCName = "AboutUsViewController"
        static let homeTableVCName = "HomeTableViewController"
    }
    
    enum CustomView{
        static let defaultCellIdentifier = "defaultCell"
        static let homeProductCellIdentifier = "productCell"
        static let homeProductCellName = "HomeCollectionViewCell"
        static let addProductImageCellIdentifier = "productImageCell"
    }
    
    enum Title{
        static let home = "Home"
        static let product = "Product"
        static let coupons = "Coupons"
        static let inventory = "Inventory"
        static let profile = "Profile"
    }
    
    enum Value{
        enum Auth{
            static let adminMail = "admin@swiftcart.com"
            static let userStatus = "isLogin"
        }
        
        enum Product{
            static let vendors = ["ADIDAS", "ASICS TIGER", "CONVERSE", "DR MARTENS", "FLEX FIT", "HERSCHEL", "NIKE", "PALLADUIM", "PUMA", "SUPRA", "TIMBERLAND", "VANS"]
            static let productTypes = ["ACCESSORIES", "SHOES", "T-SHIRTS"]
            static let inventoryManager = "shopify"
        }

        enum Inventory{
            static let locationId: Int64 = 71569309743
        }
        
        enum Coupons{
            static let valueType = ["fixed_amount", "percentage"]
            static let targetType = ["line_item", "shipping_line"]
            static let allocationMethod = ["across", "each"]
            static let selection = "all"
        }
    }
    
    enum SystemImage{
        static let home = UIImage(systemName: "house")
        static let product = UIImage(systemName: "bag")
        static let coupons = UIImage(systemName: "tag.slash")
        static let inventory = UIImage(systemName: "tray")
        static let trash = UIImage(systemName: "trash")
        static let profile = UIImage(systemName: "person.crop.circle")
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
            static let PercentagePlaceholder = UIImage(named: "PercentagePlaceholder")
            static let DiscountPlaceholder = UIImage(named: "DiscountPlaceholder")
            static let ShippingPlaceholder = UIImage(named: "ShippingPlaceholder")
            static let InventoryLocation = UIImage(named: "InventoryLocation")
            static let InventoryItem = UIImage(named: "InventoryItem")
            static let Product = UIImage(named: "Product")
            static let Team = UIImage(named: "Team")
        }
    }
    
    enum Endpoint{
        enum Product{
            static let product = "products.json" // All Product & Add
            static let productDetail = "products/{ItemId}.json" // Delete & Update
            static let count = "products/count.json"
        }
        enum Coupons{
            static let priceRules = "price_rules.json"
            static let priceRuleDetails = "price_rules/{ItemId}.json"
            static let priceRuleCount = "price_rules/count.json"
            static let discountCodes = "price_rules/{ItemId}/discount_codes.json"
            static let discountCount = "discount_codes/count.json"
            static let discountCodeDetail = "price_rules/{ItemId}/discount_codes/{DetailId}.json"
        }
        enum Inventory{
            static let inventoryLevels = "locations/71569309743/inventory_levels.json"
            static let inventoryItem = "inventory_items.json?ids={ItemId}"
            static let setInventoryItem = "inventory_levels/set.json"
            static let locationCount = "locations/count.json"
        }
    }
    
}
