//
//  Constants.swift
//  SwiftCart Admin
//
//  Created by Mac on 19/06/2024.
//

import Foundation
import UIKit

public enum K {
    
    enum Main{
        static let storyboardName = "Main"
        static let authVCName = "AuthViewController"
        static let homeVCName = "HomeViewController"
        static let couponsVCName = "CouponsViewController"
    }
    
    enum CustomView{
        static let emptyCell = "emptyCell"
        static let homeProductCell = "productCell"
        static let homeProductCellName = "HomeCollectionViewCell"
    }
    
    enum Title{
        static let home = "Home"
        static let coupons = "Coupons"
    }
    
    enum ImageSystemName{
        static let home = "house"
        static let coupons = "tag.slash"
    }
    
    enum Assets{
        enum Color{
            static let accentColor = UIColor(named: "AccentColor")
            static let colorBlack = UIColor(named: "ColorBlack")
            static let colorRed = UIColor(named: "ColorRed")
            static let textBackground = UIColor(named: "TextBackgorund")
            static let textForeground = UIColor(named: "TextForeground")
            static let viewBackground = UIColor(named: "ViewBackgrond")
        }
        enum Image{
            static let productPlaceholder = UIImage(named: "ProductPlaceholder")
        }
    }
    
    enum Endpoint{
        static let product = "products.json" // All Product & Add
        static let productDetail = "products/{ItemId}.json" // Delete & Update
    }
//    let endpoint = K.endPoints.getOrPostAddress.rawValue.replacingOccurrences(of: "{customer_id}", with: customerID)

    
}
