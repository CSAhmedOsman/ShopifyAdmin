//
//  PriceRuleModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 21/06/2024.
//

import Foundation

struct PriceRuleResponse: Codable {
    let priceRule: PriceRule?
    let priceRules: [PriceRule]?
    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
        case priceRules = "price_rules"
    }
}

struct PriceRule: Codable {
    let id: Int64?
    let valueType: String?
    let value: String?
    let customerSelection: String?
    let targetType: String?
    let targetSelection: String?
    let allocationMethod: String?
    let allocationLimit: Int?
    let oncePerCustomer: Bool?
    let usageLimit: Int?
    let startsAt: String?
    let endsAt: String?
    let createdAt: String?
    let updatedAt: String?
    let entitledCollectionIds: [Int]?
    let entitledProductIds: [Int]?
    let entitledVariantIds: [Int]?
    let entitledCountryIds: [Int]?
    let customerSegmentPrerequisiteIds: [Int]?
    let prerequisiteCustomerIds: [Int]?
    let prerequisiteCollectionIds: [Int]?
    let prerequisiteProductIds: [Int]?
    let prerequisiteVariantIds: [Int]?
    let prerequisiteSubtotalRange: SubtotalRange?
    let prerequisiteQuantityRange: QuantityRange?
    let prerequisiteShippingPriceRange: ShippingPriceRange?
    let prerequisiteToEntitlementQuantityRatio: QuantityRatio?
    let prerequisiteToEntitlementPurchase: EntitlementPurchase?
    let title: String?
    let adminGraphqlApiId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case allocationLimit = "allocation_limit"
        case oncePerCustomer = "once_per_customer"
        case usageLimit = "usage_limit"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case entitledProductIds = "entitled_product_ids"
        case entitledVariantIds = "entitled_variant_ids"
        case entitledCollectionIds = "entitled_collection_ids"
        case entitledCountryIds = "entitled_country_ids"
        case prerequisiteProductIds = "prerequisite_product_ids"
        case prerequisiteVariantIds = "prerequisite_variant_ids"
        case prerequisiteCollectionIds = "prerequisite_collection_ids"
        case customerSegmentPrerequisiteIds = "customer_segment_prerequisite_ids"
        case prerequisiteCustomerIds = "prerequisite_customer_ids"
        case prerequisiteSubtotalRange = "prerequisite_subtotal_range"
        case prerequisiteQuantityRange = "prerequisite_quantity_range"
        case prerequisiteShippingPriceRange = "prerequisite_shipping_price_range"
        case prerequisiteToEntitlementQuantityRatio = "prerequisite_to_entitlement_quantity_ratio"
        case prerequisiteToEntitlementPurchase = "prerequisite_to_entitlement_purchase"
        case title
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct SubtotalRange: Codable {
    // You might want to define specific properties for subtotal range if necessary
}

struct QuantityRange: Codable {
    // You might want to define specific properties for quantity range if necessary
}

struct ShippingPriceRange: Codable {
    // You might want to define specific properties for shipping price range if necessary
}

struct QuantityRatio: Codable {
    let prerequisiteQuantity: Int?
    let entitledQuantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case prerequisiteQuantity = "prerequisite_quantity"
        case entitledQuantity = "entitled_quantity"
    }
}

struct EntitlementPurchase: Codable {
    let prerequisiteAmount: Int?
    
    enum CodingKeys: String, CodingKey {
        case prerequisiteAmount = "prerequisite_amount"
    }
}
