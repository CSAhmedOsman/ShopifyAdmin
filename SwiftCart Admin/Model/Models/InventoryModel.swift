//
//  Inventory.swift
//  SwiftCart Admin
//
//  Created by Mac on 24/06/2024.
//

import Foundation

import Foundation

struct InventoryLevelResponse: Codable {
    var inventoryLevels: [InventoryLevel]?
    
    enum CodingKeys: String, CodingKey {
        case inventoryLevels = "inventory_levels"
    }
}

struct InventoryLevel: Codable {
    var available: Int?
    var inventoryItemId: Int64
    var locationId: Int64 = K.Value.Inventory.locationId
    var inventoryManagement: String?
    var title: String?
    var variant: String?
    var price: String?
    var imageSrc: String?
    
    enum CodingKeys: String, CodingKey {
        case available
        case inventoryItemId = "inventory_item_id"
        case locationId = "location_id"
    }
}
